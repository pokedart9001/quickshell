pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

import "./animations"
import "./globals"
import "./theme"

WlSessionLock {
    id: lockScreen
    locked: SessionLock.locked

    required property string wallpaperSource

    WlSessionLockSurface {
        id: surface
        color: "transparent"

        Item {
            id: background
            anchors.fill: parent

            Image {
                id: wallpaper
                anchors.fill: parent

                source: lockScreen.wallpaperSource
                visible: false
            }

            MultiEffect {
                anchors.fill: wallpaper
                source: wallpaper
                autoPaddingEnabled: false

                blurEnabled: true
                blur: 1
                blurMax: 16

                brightness: -0.05
                contrast: 0.2
                saturation: -0.1

                visible: wallpaper.status === Image.Ready
            }
        }

        Item {
            id: content
            anchors.fill: parent

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: 0.3
                shadowHorizontalOffset: 5
                shadowVerticalOffset: 5
            }

            ShakeAnimation {
                id: shakeAnimation

                target: password
                property: "shakeX"
                intensity: 2
            }

            Connections {
                target: SessionLock

                function onAuthFailedChanged() {
                    if (SessionLock.authFailed)
                        shakeAnimation.restart();
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                Text {
                    id: clockText
                    Layout.alignment: Qt.AlignHCenter

                    opacity: 0.7

                    color: Colors.mauve
                    font {
                        pointSize: 96
                        weight: 700
                    }

                    style: Text.Outline
                    styleColor: Colors.crust

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: Qt.formatDateTime(Clock.getDate(), "h:mm AP")
                }

                Text {
                    id: dateText
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -10

                    opacity: 0.7

                    color: Colors.mauve
                    font {
                        pointSize: 32
                        weight: 400
                    }

                    style: Text.Outline
                    styleColor: Colors.crust

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: Qt.formatDateTime(Clock.getDate(), "dddd, MMMM d")
                }

                Item {
                    implicitHeight: 300
                }

                ClippingRectangle {
                    readonly property int size: 100

                    implicitWidth: size
                    implicitHeight: size
                    radius: height / 2

                    Layout.alignment: Qt.AlignHCenter

                    color: "transparent"
                    border {
                        color: Colors.lavender
                        width: 1
                    }

                    IconImage {
                        id: profileImage
                        anchors.fill: parent

                        source: "file://" + Quickshell.env("HOME") + "/.face.icon"
                    }
                }

                Process {
                    id: name
                    running: true
                    command: ["sh", "-c", "getent passwd " + Quickshell.env("USER") + " | cut -d ':' -f 5"]

                    property string desc
                    stdout: StdioCollector {
                        onStreamFinished: name.desc = this.text
                    }
                }

                Text {
                    id: greetingText
                    Layout.alignment: Qt.AlignHCenter

                    opacity: 0.7

                    color: Colors.text
                    font {
                        pointSize: 16
                        weight: 400
                    }

                    style: Text.Outline
                    styleColor: Colors.crust

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: "Hello, " + name.desc
                }

                Item {
                    implicitHeight: 30
                }

                TextField {
                    id: password
                    enabled: !SessionLock.authenticating

                    Layout.preferredWidth: 500
                    Layout.alignment: Qt.AlignHCenter

                    property real shakeX: 0
                    transform: Translate {
                        x: password.shakeX
                    }

                    padding: 10
                    leftPadding: 16
                    rightPadding: 16

                    color: Colors.text
                    font.pointSize: 24

                    background: Rectangle {
                        color: Colors.base
                        border {
                            color: SessionLock.authFailed ? Colors.red : Colors.lavender
                            width: 1
                        }
                        radius: height / 2.5
                    }

                    cursorDelegate: Rectangle {
                        opacity: 0
                    }

                    selectByMouse: false

                    placeholderText: SessionLock.authenticating ? "Verifying..." : "Enter password..."
                    placeholderTextColor: Colors.surface2

                    echoMode: TextInput.Password
                    passwordCharacter: "∙"

                    focus: true
                    Component.onCompleted: forceActiveFocus()
                    onActiveFocusChanged: forceActiveFocus()

                    onAccepted: {
                        if (text.length > 0) {
                            SessionLock.authenticate(text);
                            text = "";
                        }
                    }
                }
            }
        }
    }
}
