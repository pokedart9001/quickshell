import QtQuick
import QtQuick.Layouts

import "../globals"
import "../theme"
import "../widgets"

RowLayout {
    spacing: 12

    Text {
        color: Colors.overlay0
        font {
            pointSize: 10
            weight: 600
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: Math.round(Weather.lowTemp) + Weather.tempSuffix
    }

    Rectangle {
        id: rect

        implicitWidth: 110
        implicitHeight: 6
        radius: height / 2

        gradient: TemperatureGradient {
            orientation: Gradient.Horizontal
            
            lowTemp: Weather.lowTemp
            highTemp: Weather.highTemp
        }

        clip: true

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            x: parent.implicitWidth * (Weather.currentTemp - Weather.lowTemp) / (Weather.highTemp - Weather.lowTemp)

            implicitWidth: parent.implicitHeight + border.width * 2
            implicitHeight: parent.implicitHeight + border.width * 2
            radius: height / 2

            color: Colors.text
            border.color: Qt.darker(Colors.crust, 1.3)
            border.width: 3
        }
    }

    Text {
        color: Colors.overlay0
        font {
            pointSize: 10
            weight: 600
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: Math.round(Weather.highTemp) + Weather.tempSuffix
    }
}
