import QtQuick
import QtQuick.Controls

import "../theme"

RoundButton {
    id: button

    required property string content
    required property color contentColor

    property int fontSize: 11
    property bool hasBorder: false

    implicitWidth: 20
    implicitHeight: 20
    radius: height / 4

    contentItem: Text {
        color: button.contentColor
        font {
            family: "CommitMono Nerd Font Propo"
            pointSize: button.fontSize
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: button.content
    }

    background: Rectangle {
        color: button.hovered || button.highlighted ? Colors.base : "transparent"
        border {
            color: Colors.surface0
            width: button.hasBorder ? 1 : 0
        }
        radius: parent.radius

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }
}
