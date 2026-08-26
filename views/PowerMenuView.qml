pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets

import "../theme"

WrapperItem {
    id: powerMenu
    margin: 10
    resizeChild: false

    readonly property list<var> options: [
        {
            icon: "",
            color: Colors.blue,
            command: ["loginctl", "lock-session"]
        },
        {
            icon: "",
            color: Colors.yellow,
            command: ["systemctl", "suspend"]
        },
        {
            icon: "⏼",
            color: Colors.red,
            command: ["reboot"]
        }
    ]

    signal accept(option: var)
    signal cancel

    Keys.onEscapePressed: cancel()
    Keys.onReturnPressed: accept(cards.currentItem.modelData)

    signal exit

    onAccept: option => {
        Quickshell.execDetached({
            command: ["systemd-run", "--user", "--scope", "--collect", "--", ...option.command],
        });
        exit();
    }

    onCancel: exit()

    ListView {
        id: cards
        anchors {
            top: parent.top
            topMargin: powerMenu.margin
        }

        implicitWidth: contentWidth
        implicitHeight: 50

        spacing: 10
        orientation: ListView.Horizontal

        focus: true
        Component.onCompleted: forceActiveFocus()

        model: powerMenu.options

        delegate: WrapperMouseArea {
            id: card
            required property var modelData
            required property int index

            margin: 10

            height: ListView.view.height
            width: height

            hoverEnabled: true
            onEntered: ListView.view.currentIndex = index
            onClicked: powerMenu.accept(modelData)

            Text {
                color: card.modelData.color
                font {
                    family: "CommitMono Nerd Font Propo"
                    pointSize: 30
                }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: card.modelData.icon
            }
        }

        highlight: Rectangle {
            color: Colors.base
            radius: height / 4
        }
    }
}
