import QtQuick
import QtQuick.Layouts

import "../animations"
import "../globals"
import "../theme"

RowLayout {
    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter

        spacing: 0

        Text {
            Layout.alignment: Qt.AlignHCenter

            color: Qt.darker(Colors.rosewater, 1.1)
            font {
                family: "CommitMono Nerd Font Propo"
                pointSize: 40
                weight: 700
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: Weather.isDay ? "" : ""
        }

        Text {
            Layout.alignment: Qt.AlignHCenter

            visible: Weather.tempSuffix !== ""
            opacity: visible ? 1 : 0

            SpringBehavior on opacity {}

            color: Weather.temperatureColor(Weather.currentTemp)
            font {
                pointSize: 20
                weight: 700
            }

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: Math.round(Weather.currentTemp) + Weather.tempSuffix
        }
    }
}
