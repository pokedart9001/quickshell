import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell.Widgets

import "../theme"

WrapperItem {
    id: card

    required property real amount
    required property color color
    required property string icon

    margin: 5

    ColumnLayout {
        spacing: -5

        Shape {
            id: arc

            readonly property int strokeWidth: 6

            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            Layout.alignment: Qt.AlignHCenter

            layer.enabled: true
            layer.samples: 4
            antialiasing: true

            ShapePath {
                fillColor: "transparent"
                strokeColor: Colors.surface0
                strokeWidth: arc.strokeWidth
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: arc.width / 2
                    centerY: arc.height / 2
                    radiusX: (arc.width - arc.strokeWidth) / 2
                    radiusY: (arc.height - arc.strokeWidth) / 2
                    startAngle: 135
                    sweepAngle: 270
                }
            }

            ShapePath {
                fillColor: "transparent"
                strokeColor: card.color
                strokeWidth: arc.strokeWidth
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: arc.width / 2
                    centerY: arc.height / 2
                    radiusX: (arc.width - arc.strokeWidth) / 2
                    radiusY: (arc.height - arc.strokeWidth) / 2
                    startAngle: 135
                    sweepAngle: 270 * card.amount
                }
            }

            Text {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 0.5

                color: card.color
                font {
                    family: "CommitMono Nerd Font Propo"
                    pointSize: 17
                    weight: 700
                }
                text: card.icon
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter

            color: card.color
            font {
                pointSize: 10
                weight: 700
            }
            text: Math.round(card.amount * 100) + "%"
        }
    }
}
