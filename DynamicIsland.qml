pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell.Services.Polkit

import "./animations"
import "./globals"
import "./theme"
import "./views"

WrapperRectangle {
    id: island

    color: Colors.crust
    border {
        color: Colors.surface0
        width: 1
    }

    width: implicitWidth
    height: implicitHeight

    CubicBehavior on width {}
    CubicBehavior on height {}

    state: "home"
    states: [
        State {
            name: "home"

            PropertyChanges {
                target: island
                page: homeViewComponent
            }
        },
        State {
            name: "notificationCenter"

            PropertyChanges {
                target: island
                page: notificationCenterViewComponent
            }
        },
        State {
            name: "powerMenu"

            PropertyChanges {
                target: island
                page: powerMenuViewComponent
            }
        },
        State {
            name: "launcher"

            PropertyChanges {
                target: island
                page: launcherViewComponent
            }
        },
        State {
            name: "dmenu"

            PropertyChanges {
                target: island
                page: dmenuViewComponent
            }
        },
        State {
            name: "authenticationPrompt"

            PropertyChanges {
                target: island
                page: authenticationPromptViewComponent
            }
        },
        State {
            name: "receivedNotification"

            PropertyChanges {
                target: island
                page: lastNotificationComponent
            }
        },
        State {
            name: "changedVolume"

            PropertyChanges {
                target: island
                page: volumeToastViewComponent
            }
        }
    ]

    transitions: Transition {
        FadeAnimation {
            opacityTarget: loader
            propertyChangeTarget: island
            propertyToChange: "page"
        }
    }

    property bool homeViewExpanded: false
    readonly property bool shouldBeRectangular: !["home", "changedVolume"].includes(state) || (state === "home" && homeViewExpanded)
    readonly property bool isOsdPopup: ["changedVolume"].includes(state)

    radius: shouldBeRectangular ? 20 : height / 2
    CubicBehavior on radius {}

    property Component page: homeViewComponent
    property list<string> dmenuOptions: []
    signal dmenuEmit(option: string)

    WrapperMouseArea {
        id: mouseArea
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (island.state === "home") {
                island.state = mouse.button === Qt.LeftButton ? "notificationCenter" : mouse.button === Qt.RightButton ? "launcher" : "home";
            }
        }

        Loader {
            id: loader
            sourceComponent: island.page
        }
    }

    Component {
        id: homeViewComponent
        HomeView {
            hovered: mouseArea.containsMouse
            onExpandedChanged: island.homeViewExpanded = expanded
            onOpenPowerMenu: island.state = "powerMenu"
        }
    }

    Component {
        id: lastNotificationComponent
        NotificationToastView {
            notification: server.lastNotification
            onExit: island.state = "home"
        }
    }

    Component {
        id: notificationCenterViewComponent
        NotificationCenterView {
            notifications: server.trackedNotifications
            onExit: island.state = "home"
        }
    }

    Component {
        id: powerMenuViewComponent
        PowerMenuView {
            onExit: island.state = "home"
        }
    }

    Component {
        id: launcherViewComponent
        LauncherView {
            onExit: island.state = "home"
        }
    }

    Component {
        id: dmenuViewComponent
        DmenuView {
            options: island.dmenuOptions
            onExit: island.state = "home"
            onEmit: option => island.dmenuEmit(option)
        }
    }

    Component {
        id: authenticationPromptViewComponent
        AuthenticationPromptView {
            liveFlow: authenticator.flow
            onExit: island.state = "home"
        }
    }

    Component {
        id: volumeToastViewComponent
        VolumeToastView {}
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false

        property Notification lastNotification

        onNotification: n => {
            n.tracked = true;
            lastNotification = n;

            if (!["notificationCenter", "powerMenu", "launcher", "authenticationPrompt"].includes(island.state))
                island.state = "receivedNotification";
        }
    }

    PolkitAgent {
        id: authenticator
        onAuthenticationRequestStarted: island.state = "authenticationPrompt"
    }

    Connections {
        target: Volume
        function onVolumeChanged() {
            if (runtime.elapsedMs() > 200) {
                island.state = "changedVolume";
                toastTimer.restart();
            }
        }
    }

    Timer {
        id: toastTimer
        interval: 2000
        running: !mouseArea.containsMouse && island.isOsdPopup

        onTriggered: island.state = "home"
    }

    ElapsedTimer {
        id: runtime
    }
}
