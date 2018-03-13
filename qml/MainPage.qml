import QtQuick 1.0
import com.nokia.meego 1.0

import "." as MyComponents


Page {
    id: mainPage

    // The layout here is for portrait, there are settings we need to change
    // for landscape.  We react on display orientation changes, that's the
    // signal "onWidthChanged".  To make sure this is called at start up, we
    // use a single shot timer, after 1ms.

    onWidthChanged: {
        displayOrientationChanged()
    }

    Timer {
        interval: 1;
        running: true;
        repeat: false;
        onTriggered: {
            displayOrientationChanged()
        }
    }
    
    function displayOrientationChanged() {
        if (width < 600) { // portrait
            button_height = 117
            button_width = 120
            key_7.anchors.top = key_enter.bottom
            key_7.anchors.left = key_enter.left
            key_divide.anchors.left = key_9.right
            key_divide.anchors.top = key_7.top
            key_multiply.anchors.left = key_6.right
            key_multiply.anchors.top = key_4.top
            key_subtract.anchors.left = key_3.right
            key_subtract.anchors.top = key_1.top
            key_add.anchors.left = key_chs.right
            key_add.anchors.top = key_0.top
            console.log("[QML INFO] Portrait")
        } else { // landscape
            button_height = 112
            button_width = 122
            key_7.anchors.top = display_box.top
            key_7.anchors.left = display_box.right
            key_divide.anchors.left = key_enter.left
            key_divide.anchors.top = key_enter.bottom
            key_multiply.anchors.left = key_divide.right
            key_multiply.anchors.top = key_divide.top
            key_subtract.anchors.left = key_multiply.right
            key_subtract.anchors.top = key_multiply.top
            key_add.anchors.left = key_subtract.right
            key_add.anchors.top = key_subtract.top
            console.log("[QML INFO] Landscape")
        }
    }

    property int button_height: 120
    property int button_width: 120

    function shift_keys() {
        switch(display_fgh.text) {
        case '':
            key_7.text = "7"
            key_8.text = "8"
            key_9.text = "9"
            key_4.text = "4"
            key_5.text = "5"
            key_6.text = "6"
            key_1.text = "1"
            key_2.text = "2"
            key_3.text = "3"
            key_0.text = "0"
            key_dot.text = "."
            key_chs.text = "±"
            break;
        case 'f':
            key_7.text = "sin"
            key_8.text = "cos"
            key_9.text = "tan"
            key_4.text = "→R"
            key_5.text = "→RAD"
            key_6.text = "→H.MS"
            key_1.text = "sinh"
            key_2.text = "cosh"
            key_3.text = "tanh"
            key_0.text = "LN"
            key_dot.text = "LOG"
            key_chs.text = "%"
            break;
        case 'g':
            key_7.text = "asin"
            key_8.text = "acos"
            key_9.text = "atan"
            key_4.text = "→P"
            key_5.text = "→DEG"
            key_6.text = "→H"
            key_1.text = "asinh"
            key_2.text = "acosh"
            key_3.text = "atanh"
            key_0.text = "e^x"
            key_dot.text = "10^x"
            key_chs.text = "Δ%"
            break;
        }
    }
    
    Row {
        id: display_box
        width: button_width * 4
        height: button_height
        anchors {
            left: parent.left
            top: parent.top
        }
        Text {
            id: display_value
            font.pixelSize: 48
            anchors {
                left: parent.left
                leftMargin: 6
                verticalCenter: parent.verticalCenter
            }
        }
        Text {
            id: display_fgh
            font.pixelSize: 18
            anchors {
                left: parent.left
                leftMargin: 60
                bottom: parent.bottom
                bottomMargin: 8
            }
        }
        Text {
            id: display_grad
            font.pixelSize: 18
            anchors {
                right: parent.right
                rightMargin: button_width * 2.5
                bottom: parent.bottom
                bottomMargin: 8
            }
        }
    }

    Button {
        id: key_second
        text: "f/g"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_fgh.text = app.shift_status()
            shift_keys()
        }
        anchors {
            left: display_box.left
            top: display_box.bottom
        }
    }
    Button {
        id: key_antilog
        text: "°DG"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_grad.text = app.grad_status()
        }
        anchors {
            left: key_second.right
            top: key_second.top
        }
    }
    Button {
        id: key_power
        text: "y^x"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.power()
        }
        anchors {
            left: key_antilog.right
            top: key_second.top
        }
    }
    Button {
        id: key_lastx
        text: "lastx"
        font.pixelSize: 32
        font.bold: true;
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.get_lastx()
        }
        anchors {
            left: key_power.right
            top: key_second.top
        }
    }
    Button {
        id: key_enter
        text: "Enter"
        font.pixelSize: 32
        width: button_width * 2
        height: button_height
        onClicked: {
            display_value.text = app.dup()
        }
        anchors {
            left: key_second.left
            top: key_second.bottom
        }
    }
    Button {
        id: key_swap
        text: "x⇄y"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.swap()
        }
        anchors {
            left: key_enter.right
            top: key_enter.top
        }
    }
    Button {
        id: key_back
        text: "←"
        font.pixelSize: 32
        font.bold: true;
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.drop()
        }
        anchors {
            left: key_swap.right
            top: key_enter.top
        }
    }
    Button {
        id: key_7
        text: "7"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_enter.left
            top: key_enter.bottom
        }
    }
    Button {
        id: key_8
        text: "8"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_7.right
            top: key_7.top
        }
    }
    Button {
        id: key_9
        text: "9"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_8.right
            top: key_7.top
        }
    }
    Button {
        id: key_divide
        text: "÷"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.divide()
        }
        anchors {
            left: key_9.right
            top: key_7.top
        }
    }
    Button {
        id: key_4
        text: "4"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_7.left
            top: key_7.bottom
        }
    }
    Button {
        id: key_5
        text: "5"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_4.right
            top: key_4.top
        }
    }
    Button {
        id: key_6
        text: "6"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_5.right
            top: key_4.top
        }
    }
    Button {
        id: key_multiply
        text: "×"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.multiply()
        }
        anchors {
            left: key_6.right
            top: key_4.top
        }
    }
    Button {
        id: key_1
        text: "1"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_4.left
            top: key_4.bottom
        }
    }
    Button {
        id: key_2
        text: "2"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_1.right
            top: key_1.top
        }
    }
    Button {
        id: key_3
        text: "3"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_2.right
            top: key_1.top
        }
    }
    Button {
        id: key_subtract
        text: "-"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.subtract()
        }
        anchors {
            left: key_3.right
            top: key_1.top
        }
    }
    Button {
        id: key_0
        text: "0"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_1.left
            top: key_1.bottom
        }
    }
    Button {
        id: key_dot
        text: "."
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.type_a_digit(text)
        }
        anchors {
            left: key_0.right
            top: key_0.top
        }
    }
    Button {
        id: key_chs
        text: "±"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.chs()
        }
        anchors {
            left: key_dot.right
            top: key_0.top
        }
    }
    Button {
        id: key_add
        text: "+"
        font.pixelSize: 32
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.add()
        }
        anchors {
            left: key_chs.right
            top: key_0.top
        }
    }
}
