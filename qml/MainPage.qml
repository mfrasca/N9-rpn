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
            display_value.text = app.get_display_value()
            display_grad.text = app.get_grad_mode()
            shift_keys()
            displayOrientationChanged()
        }
    }
    
    function displayOrientationChanged() {
        if (width < 600) { // portrait
            button_height = (854 - 35) / 10
            button_width = 480 / 5
            kpbutton_width = 480 / 4
            key_enter.anchors.top = key_31.bottom
            key_enter.anchors.left = key_31.left
            console.log("[QML INFO] Portrait")
        } else { // landscape
            button_height = (480 - 35) / 5
            button_width = 854 / 9
            kpbutton_width = 854 / 9
            key_enter.anchors.top = display_box.top
            key_enter.anchors.left = display_box.right
            console.log("[QML INFO] Landscape")
        }
    }

    function press_a_digit(text) {
        if (text == '.') {
            display_fgh.text = ''
        }
        switch (display_fgh.text) {
            
        case '': {
            display_value.text = app.type_a_digit(text)
        } break;
            
        case 'f': {
            display_value.text = app.fix(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        } break;
            
        case 'g': {
            display_value.text = app.sci(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        } break;
            
        }
    }
    
    property int button_height: 120
    property int button_width: 120
    property int kpbutton_width: 120

    function shift_keys() {
        switch(display_fgh.text) {
        case '':
            key_13.text = "x²"
            key_14.text = "y^x"
            key_15.text = "ln"
            key_22.text = "%"
            key_23.text = "sin"
            key_24.text = "cos"
            key_25.text = "tan"
            key_31.text = "Σ+"
            key_32.text = "avg"
            key_33.text = "x!"
            key_34.text = "1/x"
            key_35.text = "R↓"
            key_enter.text = "Enter"
            key_43.text = "x⇄y"
            key_44.text = "⬅"
            break;
        case 'f':
            key_13.text = "sqrt"
            key_14.text = ""
            key_15.text = "e^x"
            key_22.text = "Δ%"
            key_23.text = "asin"
            key_24.text = "acos"
            key_25.text = "atan"
            key_31.text = "L.R."
            key_32.text = "est"
            key_33.text = "Py,x"
            key_34.text = ""
            key_35.text = "R↑"
            key_enter.text = "Enter"
            key_43.text = "x⇄y"
            key_44.text = "⬅"
            break;
        case 'g':
            key_13.text = ""
            key_14.text = ""
            key_15.text = "π"
            key_22.text = "%T"
            key_23.text = "sinh"
            key_24.text = "cosh"
            key_25.text = "tanh"
            key_31.text = "Σ-"
            key_32.text = "s"
            key_33.text = "Cy,x"
            key_34.text = ""
            key_35.text = "clΣ"
            key_enter.text = "lastx"
            key_43.text = "over"
            key_44.text = "clear"
            break;
        }
        stack_depth.text = app.get_stack_depth()
        stats_count.text = app.get_stats_count()
    }
    
    Row {
        id: display_box
        width: button_width * 5
        height: button_height * 2
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
        Text {
            id: stats_count
            font.pixelSize: 18
            anchors {
                left: parent.left
                leftMargin: button_width * 4.25
                bottom: parent.bottom
                bottomMargin: 8
            }
        }
        Text {
            id: stack_depth
            font.pixelSize: 18
            anchors {
                right: parent.right
                rightMargin: button_width * 1.25
                bottom: parent.bottom
                bottomMargin: 8
            }
        }
    }

    Button {
        id: key_11
        text: "f"
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_fgh.text = app.shift_status('f')
            shift_keys()
        }
        anchors {
            left: display_box.left
            top: display_box.bottom
        }
    }
    Button {
        id: key_12
        text: "g"
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_fgh.text = app.shift_status('g')
            shift_keys()
        }
        anchors {
            left: key_11.right
            top: key_11.top
        }
    }
    Button {
        id: key_13
        text: "x²"
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_12.right
            top: key_11.top
        }
    }
    Button {
        id: key_14
        text: "x²"
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_13.right
            top: key_11.top
        }
    }
    Button {
        id: key_15
        text: "lastx"
        font.pixelSize: 26
        font.bold: true;
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_14.right
            top: key_11.top
        }
    }
    Button {
        id: key_21
        text: "mode"
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_grad.text = app.grad_mode()
        }
        anchors {
            left: key_11.left
            top: key_11.bottom
        }
    }
    Button {
        id: key_22
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_21.right
            top: key_21.top
        }
    }
    Button {
        id: key_23
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_22.right
            top: key_21.top
        }
    }
    Button {
        id: key_24
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_23.right
            top: key_21.top
        }
    }
    Button {
        id: key_25
        text: "lastx"
        font.pixelSize: 26
        font.bold: true;
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_24.right
            top: key_21.top
        }
    }
    Button {
        id: key_31
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_21.left
            top: key_21.bottom
        }
    }
    Button {
        id: key_32
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_31.right
            top: key_31.top
        }
    }
    Button {
        id: key_33
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_32.right
            top: key_31.top
        }
    }
    Button {
        id: key_34
        font.pixelSize: 26
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_33.right
            top: key_31.top
        }
    }
    Button {
        id: key_35
        font.pixelSize: 26
        font.bold: true;
        width: button_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_34.right
            top: key_31.top
        }
    }
    Button {
        id: key_enter
        font.pixelSize: 26
        width: kpbutton_width * 2
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_31.left
            top: key_31.bottom
        }
    }
    Button {
        id: key_43
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_enter.right
            top: key_enter.top
        }
    }
    Button {
        id: key_44
        font.pixelSize: 26
        font.bold: true;
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.execute(text)
            display_fgh.text = app.shift_status('keep')
            shift_keys()
        }
        anchors {
            left: key_43.right
            top: key_enter.top
        }
    }
    Button {
        id: key_7
        text: "7"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: { press_a_digit(text) }
        anchors {
            left: key_enter.left
            top: key_enter.bottom
        }
    }
    Button {
        id: key_8
        text: "8"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_7.right
            top: key_7.top
        }
    }
    Button {
        id: key_9
        text: "9"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_8.right
            top: key_7.top
        }
    }
    Button {
        id: key_divide
        text: "÷"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.divide()
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_9.right
            top: key_7.top
        }
    }
    Button {
        id: key_4
        text: "4"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_7.left
            top: key_7.bottom
        }
    }
    Button {
        id: key_5
        text: "5"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_4.right
            top: key_4.top
        }
    }
    Button {
        id: key_6
        text: "6"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_5.right
            top: key_4.top
        }
    }
    Button {
        id: key_multiply
        text: "×"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.multiply()
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_6.right
            top: key_4.top
        }
    }
    Button {
        id: key_1
        text: "1"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_4.left
            top: key_4.bottom
        }
    }
    Button {
        id: key_2
        text: "2"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_1.right
            top: key_1.top
        }
    }
    Button {
        id: key_3
        text: "3"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_2.right
            top: key_1.top
        }
    }
    Button {
        id: key_subtract
        text: "-"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.subtract()
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_3.right
            top: key_1.top
        }
    }
    Button {
        id: key_0
        text: "0"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_1.left
            top: key_1.bottom
        }
    }
    Button {
        id: key_dot
        text: "."
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {press_a_digit(text)}
        anchors {
            left: key_0.right
            top: key_0.top
        }
    }
    Button {
        id: key_chs
        text: "+/-"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.chs()
            display_fgh.text = app.shift_status('keep')
            shift_keys()
        }
        anchors {
            left: key_dot.right
            top: key_0.top
        }
    }
    Button {
        id: key_add
        text: "+"
        font.pixelSize: 26
        width: kpbutton_width
        height: button_height
        onClicked: {
            display_value.text = app.add()
            display_fgh.text = app.shift_status('')
            shift_keys()
        }
        anchors {
            left: key_chs.right
            top: key_0.top
        }
    }
}
