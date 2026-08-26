import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Polkit

import "../animations"
import "../theme"
import "../widgets"

WrapperItem {
    id: prompt

    margin: 8
    resizeChild: false

    required property AuthFlow liveFlow

    property AuthFlow flow
    Component.onCompleted: flow = liveFlow

    signal exit

    Keys.onEscapePressed: liveFlow.cancelAuthenticationRequest()
    Keys.onReturnPressed: {
        liveFlow.submit(password.text);
        password.clear();
    }

    RetainableLock {
        object: prompt.flow
        locked: true
    }

    ShakeAnimation {
        id: shakeAnimation

        target: password
        property: "shakeX"
    }

    Connections {
        target: prompt.flow

        function onAuthenticationFailed() {
            shakeAnimation.restart();
        }

        function onAuthenticationSucceeded() {
            prompt.exit();
        }

        function onIsCancelledChanged() {
            prompt.exit();
        }

        function onAuthenticationRequestCancelled() {
            prompt.exit();
        }
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.topMargin: prompt.margin

        spacing: 8

        RowLayout {
            visible: prompt.flow?.isResponseRequired ?? false
            opacity: visible ? 1 : 0

            CubicBehavior on opacity {}

            spacing: 8

            IconImage {
                implicitSize: 35
                source: Quickshell.iconPath(prompt.flow?.iconName, "dialog-password")
            }

            ColumnLayout {
                Text {
                    Layout.maximumWidth: 500

                    color: Colors.text
                    font {
                        pointSize: 11
                        weight: 500
                    }

                    text: prompt.flow?.message ?? ""
                    wrapMode: Text.WordWrap
                }

                Text {
                    visible: prompt.flow?.supplementaryMessage ? true : false
                    Layout.maximumWidth: 500

                    color: Colors.subtext0
                    font {
                        pointSize: 11
                        weight: 400
                    }

                    text: prompt.flow?.supplementaryMessage ?? ""
                    wrapMode: Text.WordWrap
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.leftMargin: -parent.spacing
            }
        }

        RowLayout {
            visible: prompt.flow?.isResponseRequired ?? false
            opacity: visible ? 1 : 0

            CubicBehavior on opacity {}

            spacing: 8
            Layout.leftMargin: 5
            Layout.rightMargin: 8

            Text {
                color: Colors.text
                font {
                    family: "CommitMono Nerd Font Propo"
                    pointSize: 15
                    weight: 700
                }
                text: ""
            }

            TextField {
                id: password

                property real shakeX: 0
                transform: Translate {
                    x: password.shakeX
                }

                Layout.fillWidth: true

                padding: 5
                leftPadding: 8

                color: Colors.text
                font.pointSize: 11

                background: Rectangle {
                    color: Colors.surface0
                    border {
                        color: (prompt.flow?.failed ?? false) ? Colors.red : Colors.lavender
                        width: 1
                    }
                    radius: height / 4
                }

                placeholderText: prompt.flow?.inputPrompt ?? "Enter password..."
                placeholderTextColor: Colors.surface2

                echoMode: (prompt.flow?.responseVisible ?? false) ? TextInput.Normal : TextInput.Password
                passwordCharacter: "∙"

                Component.onCompleted: forceActiveFocus()
            }
        }

        RowLayout {
            spacing: 10
            Layout.leftMargin: 5
            Layout.rightMargin: 10

            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

            visible: !(prompt.flow?.isResponseRequired ?? false)
            opacity: visible ? 1 : 0

            CubicBehavior on opacity {}

            LoadingSpinner {}

            Text {
                color: Colors.surface0
                font {
                    pointSize: 14
                    weight: 500
                }
                text: "Processing authentication request..."
            }
        }
    }
}
