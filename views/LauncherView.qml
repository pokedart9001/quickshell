import QtQuick
import Quickshell

import "../widgets"

Picker {
    signal exit

    entries: [...DesktopEntries.applications.values].sort((a, b) => a.name < b.name ? -1 : a.name > b.name ? 1 : 0).map(value => ({
                name: value.name,
                icon: Quickshell.iconPath(value.icon, "application-x-executable"),
                command: value.command,
                workingDirectory: value.workingDirectory
            }))

    placeholderText: "Open application..."

    onAccept: entry => {
        Quickshell.execDetached({
            command: ["systemd-run", "--user", "--scope", "--collect", "--", ...entry.command],
            workingDirectory: entry.workingDirectory
        });
        exit();
    }

    onCancel: exit()
}
