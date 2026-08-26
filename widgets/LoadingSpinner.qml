import QtQuick
import QtQuick.Shapes

import "../theme"

Item {
    id: spinner

    property int size: 24

    width: size
    height: size

    Shape {
        anchors.fill: parent

        layer.enabled: true
        layer.samples: 4
        antialiasing: true

        ShapePath {
            strokeWidth: 3
            strokeColor: Colors.surface0
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: spinner.width / 2
                centerY: spinner.height / 2
                radiusX: 9
                radiusY: 9
                startAngle: 0
                sweepAngle: 360
            }
        }

        ShapePath {
            strokeWidth: 3
            strokeColor: Colors.surface2
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: spinner.width / 2
                centerY: spinner.height / 2
                radiusX: 9
                radiusY: 9
                startAngle: 0
                sweepAngle: 120
            }
        }

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 700
            loops: Animation.Infinite
            easing.type: Easing.Linear
        }
    }
}
