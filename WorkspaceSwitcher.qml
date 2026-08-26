import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import "./theme"

WrapperRectangle {
    color: Colors.crust
    border {
        color: Colors.surface0
        width: 1
    }

    implicitHeight: 24
    radius: height / 2

    leftMargin: 2
    rightMargin: 2
    extraMargin: 3

    RowLayout {
        Repeater {
            model: ScriptModel {
                values: Hyprland.workspaces.values.filter(ws => ws.toplevels.values.length > 0 || ws.focused)
            }

            Button {
                id: workspaceButton
                required property HyprlandWorkspace modelData

                Layout.fillHeight: true
                Layout.preferredWidth: modelData.focused ? 45 : 25
                Behavior on Layout.preferredWidth {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                contentItem: Text {
                    readonly property list<string> icons: ["", "", "", "", ""]
                    readonly property int index: workspaceButton.modelData.id

                    color: Colors.base
                    font {
                        family: "CommitMono Nerd Font Propo"
                        pointSize: 10
                        weight: 600
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    text: index < icons.length ? icons[index] : index
                }

                background: Rectangle {
                    color: workspaceButton.modelData.focused ? Colors.lavender : workspaceButton.hovered ? Colors.pink : Colors.base
                    radius: height / 2

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                onClicked: modelData.activate()
            }
        }
    }
}

