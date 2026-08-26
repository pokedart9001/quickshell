import QtQuick
import QtQuick.Layouts

import "../globals"
import "../theme"

RowLayout {
    Layout.alignment: Qt.AlignHCenter

    Repeater {
        model: [
            {
                amount: SystemStats.cpuUsage,
                color: Colors.peach,
                icon: ""
            },
            {
                amount: SystemStats.memUsage,
                color: Colors.yellow,
                icon: ""
            },
            {
                amount: SystemStats.diskUsage,
                color: Colors.green,
                icon: ""
            }
        ]

        PercentageCard {
            required property var modelData

            amount: modelData.amount
            color: modelData.color
            icon: modelData.icon
        }
    }
}
