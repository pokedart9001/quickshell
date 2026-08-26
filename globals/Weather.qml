pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../theme"

Singleton {
    readonly property real currentTemp: weatherInfo.currentTemp
    readonly property string tempSuffix: weatherInfo.tempSuffix
    readonly property bool isDay: weatherInfo.isDay

    readonly property list<real> hourlyTemps: weatherInfo.hourlyTemps

    function lerp(a, b, t) {
        return a + (b - a) * t;
    }

    function colorLerp(a, b, t) {
        return Qt.rgba(lerp(a.r, b.r, t), lerp(a.g, b.g, t), lerp(a.b, b.b, t), 1);
    }

    function temperatureColor(temp) {
        if (temp <= 32)
            return Colors.blue;

        if (temp <= 50)
            return colorLerp(Colors.blue, Colors.teal, (temp - 32) / 18);

        if (temp <= 65)
            return colorLerp(Colors.teal, Colors.green, (temp - 50) / 15);

        if (temp <= 80)
            return colorLerp(Colors.green, Colors.yellow, (temp - 65) / 15);

        if (temp <= 95)
            return colorLerp(Colors.yellow, Colors.peach, (temp - 80) / 15);

        return Colors.red;
    }

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
            command: ["curl", "-s", `https://api.open-meteo.com/v1/forecast?latitude=${locationInfo.latitude}&longitude=${locationInfo.longitude}&current=temperature_2m,is_day&hourly=temperature_2m&timezone=auto&temperature_unit=fahrenheit&forecast_days=1`]

            property real currentTemp
            property string tempSuffix
            property bool isDay

            property list<real> hourlyTemps

            stdout: StdioCollector {
                waitForEnd: true

                onStreamFinished: {
                    const info = JSON.parse(this.text);

                    weatherInfo.currentTemp = info.current.temperature_2m;
                    weatherInfo.tempSuffix = info.current_units.temperature_2m;
                    weatherInfo.isDay = info.current.isDay === 1;

                    weatherInfo.hourlyTemps = info.hourly.temperature_2m;
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
