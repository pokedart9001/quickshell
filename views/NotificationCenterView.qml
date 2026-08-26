import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../animations"
import "../widgets"
import "../theme"

WrapperItem {
    id: center
    margin: 10
    resizeChild: false

    required property var notifications

    signal exit

    ColumnLayout {
        anchors.top: parent.top
        anchors.topMargin: center.margin

        spacing: 10

        RowLayout {
            spacing: 20

            MenuButton {
                content: ""
                contentColor: Colors.surface2

                onClicked: center.exit()
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                color: Colors.text
                font {
                    pointSize: 13
                    weight: 600
                }
                text: "Notifications"
            }

            Item {
                Layout.fillWidth: true
            }

            MenuButton {
                content: ""
                contentColor: Colors.red

                onClicked: {
                    while (history.count > 0) {
                        (history.itemAtIndex(0).modelData as Notification).dismiss();
                        history.forceLayout();
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: -center.margin
            Layout.rightMargin: -center.margin
            implicitHeight: 1
            color: Colors.surface0
        }

        ListView {
            id: history

            visible: center.notifications.values.length > 0
            opacity: visible ? 1 : 0

            CubicBehavior on opacity {}

            Layout.preferredWidth: 500
            Layout.preferredHeight: Math.min(contentHeight, 245)
            clip: true

            spacing: 5

            add: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    to: 0
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            model: center.notifications

            delegate: WrapperMouseArea {
                id: card
                required property Notification modelData

                width: ListView.view.width

                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        const defaultAction = modelData?.actions.find(action => action.identifier === "default");
                        defaultAction?.invoke();

                        if (!defaultAction || (modelData?.resident ?? false)) {
                            modelData.dismiss();
                        }
                    } else {
                        modelData?.dismiss();
                    }
                }

                WrapperRectangle {
                    id: container

                    color: Colors.mantle
                    border {
                        color: card.containsMouse && !closeButton.hovered ? Colors.lavender : "transparent"
                        width: 1
                    }
                    radius: height / 6

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    Item {
                        implicitWidth: info.implicitWidth
                        implicitHeight: info.implicitHeight

                        NotificationCard {
                            id: info
                            anchors.fill: parent

                            image: (card.modelData?.image ?? "") !== "" ? card.modelData.image : Quickshell.iconPath(card.modelData?.appIcon, true)
                            summary: card.modelData?.summary ?? ""
                            body: card.modelData?.body ?? ""

                            desiredHeight: 75
                            explicitWidth: true
                            explicitHeight: true
                        }

                        MenuButton {
                            id: closeButton

                            readonly property int size: 15
                            readonly property int margin: 5

                            implicitWidth: size
                            implicitHeight: size
                            fontSize: 10

                            anchors {
                                top: parent.top
                                right: parent.right

                                topMargin: margin
                                rightMargin: margin
                            }

                            content: ""
                            contentColor: Colors.red

                            onClicked: card.modelData.dismiss()
                        }
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

            visible: center.notifications.values.length === 0
            opacity: visible ? 1 : 0

            CubicBehavior on opacity {}

            color: Colors.surface0
            font {
                pointSize: 14
                weight: 600
            }
            text: "No notifications"
        }
    }
}
