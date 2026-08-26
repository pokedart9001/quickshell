import QtQuick
import QtQuick.Controls

import "../animations"
import "../theme"

Switch {
    id: control

    property int size: 25
    property int gap: 3

    property color accentColor: Colors.green
    property string label: ""

    contentItem: Item {}

    implicitWidth: size * 2
    implicitHeight: size

    indicator: Rectangle {
        implicitWidth: control.implicitWidth
        implicitHeight: control.implicitHeight
        radius: control.size / 2

        color: control.checked ? control.accentColor : Colors.mantle
        border.color: control.checked ? control.accentColor : Colors.surface1

        Behavior on color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            x: control.checked ? control.implicitWidth - control.size + control.gap : control.gap
            y: control.gap

            SpringBehavior on x {}

            implicitWidth: control.size - control.gap * 2
            implicitHeight: control.size - control.gap * 2
            radius: control.size / 2

            color: control.checked ? Qt.lighter(Colors.text) : Colors.text

            Text {
                anchors.centerIn: parent

                color: Qt.darker(control.indicator.color, 1.2)
                font {
                    family: "CommitMono Nerd Font Propo"
                    pixelSize: control.size / 2
                }

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                text: control.label
            }
        }
    }
}
