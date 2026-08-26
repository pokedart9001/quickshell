pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property real cpuUsage: cpuInfo.cpuUsage
    readonly property real memUsage: memInfo.memUsage
    readonly property real diskUsage: diskInfo.diskUsage

    Scope {
        Process {
            id: cpuInfo
            command: ["head", "-1", "/proc/stat"]

            property real cpuUsage
            property int previousIdle: 0
            property int previousTotal: 0

            stdout: SplitParser {
                onRead: data => {
                    const p = data.trim().split(/\s+/).slice(1).map(s => parseInt(s));

                    const currentIdle = p[3] + p[4];
                    const currentTotal = p.reduce((acc, cur) => acc + cur);

                    if (cpuInfo.previousTotal > 0) {
                        const idleDelta = currentIdle - cpuInfo.previousIdle;
                        const totalDelta = currentTotal - cpuInfo.previousTotal;

                        cpuInfo.cpuUsage = 1 - idleDelta / totalDelta;
                    }

                    cpuInfo.previousIdle = currentIdle;
                    cpuInfo.previousTotal = currentTotal;
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: memInfo
            command: ["sh", "-c", "free | grep 'Mem'"]

            property real memUsage

            stdout: SplitParser {
                onRead: data => {
                    const p = data.trim().split(/\s+/).slice(1, 3).map(s => parseInt(s));
                    memInfo.memUsage = p[1] / p[0];
                }
            }

            Component.onCompleted: running = true
        }

        Process {
            id: diskInfo
            command: ["sh", "-c", "df | grep 'nvme0n1p2'"]

            property real diskUsage

            stdout: SplitParser {
                onRead: data => {
                    const p = data.trim().split(/\s+/).slice(1, 3).map(s => parseInt(s));
                    diskInfo.diskUsage = p[1] / p[0];
                }
            }

            Component.onCompleted: running = true
        }

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered: {
                cpuInfo.running = true;
                memInfo.running = true;
                diskInfo.running = true;
            }
        }
    }
}
