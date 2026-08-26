//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import "./globals"

Scope {
    PanelWindow {
        id: panel

        readonly property bool isKeyboardExclusive: ["powerMenu", "launcher", "dmenu", "authenticationPrompt"].includes(island.state)
        WlrLayershell.keyboardFocus: isKeyboardExclusive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Screen.height

        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Component.onCompleted: exclusiveZone = island.height

        mask: Region {
            Region {
                item: workspaceSwitcher
                radius: workspaceSwitcher.radius
            }
            Region {
                item: island
                radius: island.radius
            }
        }

        WorkspaceSwitcher {
            id: workspaceSwitcher
            anchors {
                top: parent.top
                left: parent.left

                topMargin: 2
                leftMargin: 5
            }
        }

        DynamicIsland {
            id: island
            anchors {
                top: parent.top
                topMargin: 2
                horizontalCenter: parent.horizontalCenter
            }

            onDmenuEmit: option => dmenuHandler.receive(option)
        }

        LockScreen {
            wallpaperSource: settings.wallpaperSource
        }
    }

    PanelWindow {
        anchors {
            top: true
            right: true
            left: true
            bottom: true
        }

        WlrLayershell.layer: WlrLayer.Background
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Image {
            anchors.fill: parent
            source: settings.wallpaperSource
        }
    }

    PersistentProperties {
        id: settings
        property string wallpaperSource: "file://" + Quickshell.env("HOME") + "/Pictures/wallpapers/others/tree-sunset.jpg"
    }

    IdleInhibitor {
        window: panel
        enabled: States.isIdleInhibitorActivated
    }

    IpcHandler {
        target: "toggle"

        function notificationCenter(): void {
            island.state = island.state === "notificationCenter" ? "home" : "notificationCenter";
        }

        function powerMenu(): void {
            island.state = island.state === "powerMenu" ? "home" : "powerMenu";
        }

        function launcher(): void {
            island.state = island.state === "launcher" ? "home" : "launcher";
        }
    }

    IpcHandler {
        id: dmenuHandler
        target: "dmenu"

        function open(input: string): void {
            input = input.trim();

            const options = input === "" ? [] : input.split('\n');
            island.dmenuOptions = options;
            island.state = "dmenu";
        }

        signal receive(output: string)
    }

    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            if (SessionLock.locked)
                return;

            SessionLock.authFailed = false;
            SessionLock.locked = true;
        }

        function isLocked(): bool {
            return SessionLock.locked;
        }
    }
}
