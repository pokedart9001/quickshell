import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import "../globals"
import "../theme"

WrapperItem {
    id: popup

    leftMargin: 5
    rightMargin: 5
    extraMargin: 5

    resizeChild: false

    readonly property real volume: Volume.volume

    RowLayout {
        id: layout
        anchors.centerIn: parent

        spacing: 7

        Text {
            color: Colors.text
            font {
                family: "CommitMono Nerd Font Propo"
                pointSize: 13
            }
            text: "󰕾"
        }

        Rectangle {
            color: Colors.surface0

            implicitWidth: 70
            implicitHeight: 6
            radius: height / 2

            Rectangle {
                anchors.left: parent.left
                color: Colors.lavender

                implicitWidth: parent.implicitWidth * popup.volume
                implicitHeight: parent.implicitHeight
                radius: parent.radius

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        Text {
            color: Colors.text
            font {
                pointSize: 10
                weight: 600
            }
            text: Math.round(popup.volume * 100) + "%"
        }
    }
}
