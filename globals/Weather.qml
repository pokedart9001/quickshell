pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property real lowTemp: weatherInfo.lowTemp
    readonly property real highTemp: weatherInfo.highTemp
    readonly property real currentTemp: weatherInfo.currentTemp

    readonly property string tempSuffix: weatherInfo.tempSuffix


    Scope {
        Process {
            id: locationInfo
            command: ["curl", "-s", "ipinfo.io/loc"]

            property real latitude
            property real longitude

            stdout: StdioCollector {
                waitForEnd: true

                onStreamFinished: {
                    const loc = this.text.trim().split(',').map(parseFloat);

                    locationInfo.latitude = loc[0];
                    locationInfo.longitude = loc[1];

                    weatherInfo.running = true;
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: weatherInfo
            command: ["curl", "-s", `https://api.open-meteo.com/v1/forecast?latitude=${locationInfo.latitude}&longitude=${locationInfo.longitude}&current=temperature_2m&daily=temperature_2m_max,temperature_2m_min&timezone=auto&forecast_days=1&temperature_unit=fahrenheit`]

            property real lowTemp
            property real highTemp
            property real currentTemp

            property string tempSuffix

            stdout: StdioCollector {
                waitForEnd: true

                onStreamFinished: {
                    const info = JSON.parse(this.text);

                    weatherInfo.currentTemp = info.current.temperature_2m;
                    weatherInfo.tempSuffix = info.current_units.temperature_2m;

                    weatherInfo.lowTemp = info.daily.temperature_2m_min[0];
                    weatherInfo.highTemp = info.daily.temperature_2m_max[0];
                }
            }
        }

        Timer {
            interval: 100000
            running: true
            repeat: true

            onTriggered: locationInfo.running = true
        }
    }
}
