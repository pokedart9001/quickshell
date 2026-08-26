import Quickshell

import "../widgets"
import "../theme"

ChoiceMenu {
    options: [
        {
            icon: "",
            color: Colors.blue,
            command: ["loginctl", "lock-session"]
        },
        {
            icon: "",
            color: Colors.yellow,
            command: ["systemctl", "suspend"]
        },
        {
            icon: "⏼",
            color: Colors.red,
            command: ["reboot"]
        }
    ]

    onAccept: option => {
        Quickshell.execDetached({
            command: ["systemd-run", "--user", "--scope", "--collect", "--", ...option.command],
        });
        exit();
    }

    onCancel: exit()
}
