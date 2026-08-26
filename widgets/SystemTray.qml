pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

GridLayout {
    id: tray
    property bool menuOpened: false

    columns: 6

    Repeater {
        model: SystemTray.items

        WrapperMouseArea {
            id: systemTrayButton
            required property SystemTrayItem modelData

            acceptedButtons: Qt.RightButton

            QsMenuAnchor {
                id: menu

                menu: systemTrayButton.modelData?.menu ?? null
                anchor {
                    item: systemTrayButton
                    rect {
                        x: systemTrayButton.mouseX
                        y: systemTrayButton.mouseY
                    }
                }

                onOpened: tray.menuOpened = true
                onClosed: tray.menuOpened = false
            }

            onClicked: mouse => {
                menu.open();
            }

            MenuButton {
                content: ""
                contentColor: "transparent"

                implicitWidth: 28
                implicitHeight: 28

                contentItem: IconImage {
                    source: systemTrayButton.modelData.icon
                }

                onClicked: systemTrayButton.modelData.activate()
            }
        }
    }
}
