pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Widgets

import "../theme"

WrapperItem {
    id: choiceMenu
    margin: 10
    resizeChild: false

    required property list<var> options

    signal accept(option: var)
    signal cancel

    Keys.onEscapePressed: cancel()
    Keys.onReturnPressed: accept(cards.currentItem.modelData)

    signal exit

    ListView {
        id: cards
        anchors {
            top: parent.top
            topMargin: choiceMenu.margin
        }

        implicitWidth: contentWidth
        implicitHeight: 50

        spacing: 10
        orientation: ListView.Horizontal

        focus: true
        Component.onCompleted: forceActiveFocus()

        model: choiceMenu.options

        delegate: WrapperMouseArea {
            id: card
            required property var modelData
            required property int index

            margin: 10

            height: ListView.view.height
            width: height

            hoverEnabled: true
            onEntered: ListView.view.currentIndex = index
            onClicked: choiceMenu.accept(modelData)

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
