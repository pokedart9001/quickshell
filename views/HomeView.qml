pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import "../animations"
import "../globals/"
import "../widgets"
import "../theme"

Item {
    id: home
    required property bool hovered
    readonly property bool expanded: hovered || tray.menuOpened

    signal openPowerMenu

    implicitWidth: expanded ? wrapper.implicitWidth : 90
    implicitHeight: expanded ? wrapper.implicitHeight : 22
    clip: true

    state: "systemMonitor"
    states: [
        State {
            name: "systemMonitor"

            PropertyChanges {
                target: loader
                sourceComponent: systemMonitor
            }
        },
        State {
            name: "musicPlayer"

            PropertyChanges {
                target: loader
                sourceComponent: musicController
            }
        }
    ]

    transitions: Transition {
        FadeAnimation {
            opacityTarget: loader
            propertyChangeTarget: loader
            propertyToChange: "sourceComponent"
        }
    }

    function cycleState() {
        const index = states.findIndex(state => state.name === this.state);
        state = states[(index + 1) % states.length].name;
    }

    WrapperItem {
        id: wrapper
        anchors {
            top: parent.top
            topMargin: home.expanded ? 0 : (home.implicitHeight - clockText.implicitHeight) / 2 - margin
            horizontalCenter: parent.horizontalCenter
        }
        CubicBehavior on anchors.topMargin {}

        margin: 10

        ColumnLayout {
            spacing: 0

            Text {
                id: clockText
                Layout.alignment: Qt.AlignHCenter

                color: home.expanded ? Colors.mauve : Colors.text
                font {
                    pointSize: home.expanded ? 16 : 10
                    weight: 700
                }

                text: Qt.formatDateTime(Clock.getDate(), "h:mm AP")

                CubicBehavior on font.pointSize {}
                Behavior on color {
                    ColorAnimation {
                        duration: 280
                        easing.type: Easing.OutQuad
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10

                opacity: home.expanded ? 1 : 0

                color: Colors.subtext0
                font.pointSize: 10

                text: Qt.formatDateTime(Clock.getDate(), "dddd, MMMM d")

                CubicBehavior on opacity {}
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: -wrapper.margin
                Layout.rightMargin: -wrapper.margin
                Layout.bottomMargin: 5
                implicitHeight: 1
                color: Colors.surface0
            }

            WrapperMouseArea {
                implicitWidth: loader.implicitWidth
                implicitHeight: loader.implicitHeight

                CubicBehavior on implicitWidth {}
                CubicBehavior on implicitHeight {}

                acceptedButtons: Qt.MiddleButton
                preventStealing: true

                onClicked: home.cycleState()

                Loader {
                    id: loader
                    sourceComponent: systemMonitor
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: -wrapper.margin
                Layout.rightMargin: -wrapper.margin
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                implicitHeight: 1
                color: Colors.surface0
            }

            SystemTray {
                id: tray

                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: -5
            }
        }
    }

    MenuButton {
        content: "⏻"
        contentColor: Colors.red
        fontSize: 10

        onClicked: home.openPowerMenu()

        radius: height / 3

        anchors {
            top: parent.top
            right: parent.right

            topMargin: 7
            rightMargin: 7
        }

        opacity: home.expanded ? 1 : 0
        Behavior on opacity {
            id: powerButtonOpacityBehavior
            NumberAnimation {
                duration: powerButtonOpacityBehavior.targetValue === 0 ? 150 : 350
                easing.type: powerButtonOpacityBehavior.targetValue === 0 ? Easing.OutQuint : Easing.InOutQuad
            }
        }

        clip: true
    }

    Component {
        id: systemMonitor
        SystemMonitor {}
    }

    Component {
        id: musicController
        MusicController {}
    }
}
