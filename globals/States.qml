pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property string homeState: "systemMonitor"
    property bool isDoNotDisturbActivated: false
    property bool isIdleInhibitorActivated: false
}
