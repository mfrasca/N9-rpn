#!/usr/bin/python
# -*- coding: utf-8 -*-
##############################################################################################
# Copyright (c) by Mario Frasca (2018)
# License:     GPL3
##############################################################################################


import sys
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import *
from PySide.QtGui import QDesktopServices as QDS

import math
import platform
import os
import json


from datetime import tzinfo, timedelta, datetime
import logging
logger = logging.getLogger(__name__)


def is_numeric(item):
    "Return True if the item is numeric"
    try:
        float(item)
        return True
    except (ValueError, TypeError):
        pass
    return False


class RpnApp(QApplication):
    "Reverse Polish Notation class"

    root = "/opt/rpncalc/"
    version = "??"
    build = "?"

    def __init__(self, argv):
        super(RpnApp, self).__init__(argv)
        logging.basicConfig()
        
        if(platform.machine().startswith('arm')):
            pass
        else:
            self.root = "./"
            self.path = "./data/"
        try:
            os.makedirs(self.path)
        except:
            pass
        
        try:
            versionfilename = os.path.join(self.root, "version")
            with open(versionfilename, 'r') as file:
                self.version = file.readline().strip()
                self.build = file.readline().strip()
                logger.info("Version: %s-%s" % (self.version, self.build))
        except Exception, e:
            logger.error("%s(%s) reading version file %s." % (type(e), e, versionfilename))

        self.config = Configuration()
        self.lastx = 0
        self.istyping = False
        self.errored = False
        self.shift = ''
        self.stack = self.config.values['stack']
        self.format = self.config.values['format']
        self.grad = self.config.values['grad']
        self.statistics = self.config.values['statistics']
        self.flat_angle = {0: 180.0, 1: math.pi, 2: 200.0}[self.grad]

    def finished(self):
        self.config.values = {
            'stack': self.stack,
            'format': self.format,
            'grad': self.grad,
            'statistics': self.statistics, }
        self.config.write()
        logger.debug("Closed")

    def get_x(self):
        if self.istyping is not False:
            x = float(self.istyping)
            self.istyping = False
        else:
            x = self.stack.pop()
        return x

    def stop_typing(self):
        if self.istyping is not False:
            self.stack.append(float(self.istyping))
            self.istyping = False

    def format_return(self):
        if not self.stack:
            return ''
        s, d = (self.format % self.stack[-1]).split('.')
        out = []
        while len(s):
            out.insert(0, s[-3:])
            s = s[:-3]
        return u' '.join(out) + '.' + d
            
    @Slot(result=str)
    def get_display_value(self):
        return self.format_return()

    @Slot(result=str)
    def get_grad_mode(self):
        return {0: '',
                1: 'RAD',
                2: 'GRAD'}[self.grad]
    
    @Slot(result=str)
    def get_lastx(self):
        "Retrieve the last used x"
        self.stack.append(self.lastx)
        return self.format_return()
    
    @Slot(result=str)
    def add(self):
        "Add two digits"
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        self.stack.append(self.stack.pop() + self.lastx)
        return self.format_return()

    @Slot(result=str)
    def subtract(self):
        "Substract two digits"
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        self.stack.append(self.stack.pop() - self.lastx)
        return self.format_return()

    @Slot(result=str)
    def multiply(self):
        "Multiply two digits"
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        self.stack.append(self.stack.pop() * self.lastx)
        return self.format_return()

    @Slot(result=str)
    def divide(self):
        "Divide two digits"
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        try:
            self.stack.append(self.stack.pop() / self.lastx)
        except ZeroDivisionError:
            self.errored = True
            return "divide: Division by Zero"
        return self.format_return()

    @Slot(str, result=str)
    def shift_status(self, toggle):
        if toggle == 'keep':
            toggle = ''
        else:
            self.stop_typing()
        if self.shift == toggle:
            self.shift = ''
        else:
            self.shift = toggle
        return self.shift

    @Slot(result=str)
    def get_shift(self):
        return self.shift

    @Slot(result=str)
    def grad_mode(self):
        self.grad = (self.grad + 1) % 3
        self.flat_angle = {
            0: 180.0,
            1: math.pi,
            2: 200.0}[self.grad]
        return {0: '',
                1: 'RAD',
                2: 'GRAD'}[self.grad]

    @Slot(result=str)
    def drop(self):
        "Drop the last inserted item out of the stack"
        if self.errored:
            self.errored = False
            return self.format_return()
        elif self.istyping is False:
            if not self.stack:
                self.errored = True
                return "drop: empty stack"
            self.stack.pop()
            return self.format_return()
        elif self.istyping:
            self.istyping = self.istyping[:-1]
            return self.istyping
        else:
            self.istyping = False
            return self.format_return()

    @Slot(str, result=str)
    def execute(self, name):
        if name not in ['Enter', u"←"]:
            self.stop_typing()
        self.shift = ''
        name = {'%': 'take_percent',
                '%T': 'percent_of_total',
                u'Δ%': 'percent_difference',
                u'x²': 'square',
                u'π': 'pi',
                '1/x': 'inv',
                'Enter': 'dup',
                u'←': 'drop',
                u"x⇄y": 'swap',
                'lastx': 'get_lastx',
                u'R↑': 'stack_up', 
                u'R↓': 'stack_down', 
                'e^x': 'exponential',
                'y^x': 'power', }.get(name, name)
        try:
            return getattr(self, name)()
        except Exception:
            self.errored = True
            return 'some error'

    def get_lastx(self):
        self.stack.append(self.lastx)
        return self.format_return()

    def take_percent(self):
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        total = self.stack[-1]
        self.stack.append(total / 100.0 * self.lastx)
        return self.format_return()

    def percent_of_total(self):
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        total = self.stack[-1]
        self.stack.append(100.0 * self.lastx / total)
        return self.format_return()

    def percent_difference(self):
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        total = self.stack[-1]
        self.stack.append(100.0 * (self.lastx - total) / total)
        return self.format_return()
    
    def stack_up(self):
        x = self.stack.pop(0)
        self.stack.append(x)
        return self.format_return()

    def stack_down(self):
        x = self.stack.pop()
        self.stack.insert(0, x)
        return self.format_return()
        
    def clear(self):
        "Clear the stack"
        self.stack = []
        return ""

    def e(self):
        "Put 'e' constant in the stack"
        self.stop_typing()
        self.stack.append(math.e)
        return self.format_return()

    def pi(self):
        "Put 'pi' constant in the stack"
        self.stop_typing()
        self.stack.append(math.pi)
        return self.format_return()

    @Slot(result=str)
    def sqrt(self):
        "Extract the square root of the digit"
        self.stop_typing()
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        try:
            self.stack.append(math.sqrt(self.lastx))
        except ValueError as e:
            self.errored = True
            self.stack.append(self.lastx)
            return "sqrt: Invalid value %s" % e
        return self.format_return()

    @Slot(result=str)
    def inv(self):
        self.stop_typing()
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        try:
            self.stack.append(1.0 / self.lastx)
        except ValueError as e:
            self.errored = True
            self.stack.append(self.lastx)
            return "1/x: Invalid value %s" % e
        return self.format_return()

    @Slot(result=str)
    def square(self):
        "Extract the square root of the digit"
        self.stop_typing()
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        self.stack.append(self.lastx * self.lastx)
        return self.format_return()

    @Slot(result=str)
    def power(self):
        "Raise y to the power of x"
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        self.stack.append(math.pow(self.stack.pop(), self.lastx))
        return self.format_return()

    @Slot(result=str)
    def exponential(self):
        "Raise e to the power of x"
        self.stop_typing()
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.get_x()
        self.stack.append(math.pow(math.e, self.lastx))
        return self.format_return()

    @Slot(result=str)
    def swap(self):
        "Swap the last two items in the stack"
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        x = self.get_x()
        y = self.stack.pop()
        self.stack.append(x)
        self.stack.append(y)
        return self.format_return()

    @Slot(result=str)
    def over(self):
        self.stop_typing()
        if len(self.stack) < 2:
            self.errored = True
            return "too few operators"
        self.stack.append(self.stack[-2])
        return self.format_return()

    @Slot(result=str)
    def chs(self):
        "Changes the sign of the last item in the stack"
        if self.istyping is not False:
            if self.istyping[0] == '-':
                self.istyping = self.istyping[1:]
            else:
                self.istyping = '-' + self.istyping
            return self.istyping
        else:
            if len(self.stack) < 1:
                self.errored = True
                return "too few operators"
            x = -self.stack.pop()
            self.stack.append(x)
            return self.format_return()

    @Slot(result=str)
    def dup(self):
        "Duplicates the last item in the stack"
        if self.istyping is False:
            if len(self.stack) < 1:
                self.errored = True
                return "too few operators"
            x = self.stack[-1]
        else:
            x = self.get_x()
        self.stack.append(x)
        return self.format_return()

    @Slot(str, result=str)
    def type_a_digit(self, digit):
        if self.istyping is False:
            self.istyping = ''
        if digit != '.' or '.' not in self.istyping:
            self.istyping += digit
        return(self.istyping)

    @Slot(str, result=str)
    def fix(self, digits):
        self.format = "%0." + digits + "f"
        return self.format_return()

    @Slot(str, result=str)
    def sci(self, digits):
        self.format = "%0." + digits + "e"
        return self.format_return()

    def sin(self):
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        self.stack.append(math.sin(self.lastx / self.flat_angle * math.pi))
        return self.format_return()

    def cos(self):
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        self.stack.append(math.cos(self.lastx / self.flat_angle * math.pi))
        return self.format_return()

    def tan(self):
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        self.stack.append(math.tan(self.lastx / self.flat_angle * math.pi))
        return self.format_return()

    def asin(self):
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        self.stack.append(math.asin(self.lastx) / math.pi * self.flat_angle)
        return self.format_return()

    def acos(self):
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        self.stack.append(math.acos(self.lastx) / math.pi * self.flat_angle)
        return self.format_return()

    def atan(self):
        if len(self.stack) < 1:
            self.errored = True
            return "too few operators"
        self.lastx = self.stack.pop()
        self.stack.append(math.atan(self.lastx) / math.pi * self.flat_angle)
        return self.format_return()

    @Slot(result=str)
    def get_version(self):
        return str(self.version) + "-" + str(self.build)


####################################################################################################
class Configuration():

    def __init__(self):
        self.configpath = os.path.join(QDS.storageLocation(QDS.DataLocation), "n9rpn")
        self.configfile = os.path.join(self.configpath, "config.json")

        logger.debug("Loading configuration from: %s" % self.configfile)
        try:
            with open(self.configfile, 'r') as handle:
                self.values = json.load(handle)
            logger.debug("Configuration loaded")
        except:
            logger.error("Failed to load configuration file!")
            self.values = {'stack': [],
                           'format': "%0.4f",
                           'grad': 0,
                           'statistics': [0, 0, 0, 0, 0, 0, ]}

    def write(self):
        logger.debug("Write configuration to: %s" % self.configfile)

        try:
            os.makedirs(self.configpath)
        except:
            pass

        try:
            with open(self.configfile, 'w') as handle:
                json.dump(self.values, handle)
            logger.debug("Configuration saved")
        except Exception, e:
            logger.error("%s(%s) writing configuration file!" % (type(e), e))



################################################################################################
if __name__ == '__main__':
    gpslogger = RpnApp(sys.argv)
    logging.basicConfig(stream=sys.stderr, level=logging.WARNING)

    view = QDeclarativeView()
    context = view.rootContext()
    context.setContextProperty("app", gpslogger)
    view.setSource(QUrl.fromLocalFile(gpslogger.root + 'qml/main.qml'))

    if(platform.machine().startswith('arm')):
        view.showFullScreen()
        view.show()

    gpslogger.exec_()  # endless loop
    gpslogger.finished()
