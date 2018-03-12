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
        if (width > 600) { // landscape
            console.log("[QML INFO] Landscape")
        } else { // portrait
            console.log("[QML INFO] Portrait")
        }
    }

    property int waypoint_no: 0

    Column {
        id: current
        width: parent.width

        Text {
            id: display_x
            font.pixelSize: 48
            width: current.width
            height: width / 5
        }

        Row {
            id: row_0
            Button {
                text: "(f)"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                }
            }
            Button {
                text: "e^x"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                }
            }
            Button {
                text: "y^x"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.power()
                }
            }
            Button {
                text: "lastx"
                font.pixelSize: 32
                font.bold: true;
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.get_lastx()
                }
            }
        }

        Row {
            id: row_1
            Button {
                text: "Enter"
                font.pixelSize: 32
                width: current.width / 2
                height: width / 2
                onClicked: {
                    display_x.text = app.dup()
                }
            }
            Button {
                text: "x⇄y"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.swap()
                }
            }
            Button {
                text: "←"
                font.pixelSize: 32
                font.bold: true;
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.drop()
                }
            }
        }
        
        Row {
            id: row_2
            Button {
                text: "7"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "8"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "9"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "÷"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.divide()
                }
            }
        }
        Row {
            id: row_3
            Button {
                text: "4"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "5"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "6"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "×"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.multiply()
                }
            }
        }
        Row {
            id: row_4
            Button {
                text: "1"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "2"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "3"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "-"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.subtract()
                }
            }
        }
        Row {
            id: row_5
            Button {
                text: "0"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "."
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.type_a_digit(text)
                }
            }
            Button {
                text: "±"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.chs()
                }
            }
            Button {
                text: "+"
                font.pixelSize: 32
                width: current.width / 4
                height: width
                onClicked: {
                    display_x.text = app.add()
                }
            }
        }

    }

}
