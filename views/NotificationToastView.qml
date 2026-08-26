import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

import "../animations"
import "../widgets"

WrapperMouseArea {
    id: root

    required property Notification notification

    Behavior on notification {
        FadeAnimation {
            opacityTarget: card
            propertyChangeTarget: root
            propertyToChange: "notification"
        }
    }

    signal exit

    NotificationCard {
        id: card

        image: ""
        summary: ""
        body: ""
    }

    onNotificationChanged: {
        if (notification) {
            card.image = notification.image !== "" ? notification.image : Quickshell.iconPath(notification.appIcon, true);
            card.summary = notification.summary;
            card.body = notification.body;
        }
    }

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            const defaultAction = notification.actions.find(action => action.identifier === "default");
            defaultAction?.invoke();

            if (!defaultAction || notification.resident) {
                notification.dismiss();
            }
        } else {
            notification.dismiss();
        }
        exit();
    }

    Timer {
        interval: 3250
        running: !root.containsMouse

        onTriggered: root.exit()
    }
}
