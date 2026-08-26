import QtQuick

import "../theme"

Gradient {
    id: grad

    required property real lowTemp
    required property real highTemp

    GradientStop {
        position: 0.0
        color: grad.temperatureColor(grad.lowTemp)
    }
    GradientStop {
        position: 0.1
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.1)
    }
    GradientStop {
        position: 0.15
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.15)
    }
    GradientStop {
        position: 0.2
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.2)
    }
    GradientStop {
        position: 0.25
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.25)
    }
    GradientStop {
        position: 0.3
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.3)
    }
    GradientStop {
        position: 0.35
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.35)
    }
    GradientStop {
        position: 0.4
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.4)
    }
    GradientStop {
        position: 0.45
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.45)
    }
    GradientStop {
        position: 0.5
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.5)
    }
    GradientStop {
        position: 0.55
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.55)
    }
    GradientStop {
        position: 0.6
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.6)
    }
    GradientStop {
        position: 0.65
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.65)
    }
    GradientStop {
        position: 0.7
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.7)
    }
    GradientStop {
        position: 0.75
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.75)
    }
    GradientStop {
        position: 0.8
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.8)
    }
    GradientStop {
        position: 0.85
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.85)
    }
    GradientStop {
        position: 0.9
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.9)
    }
    GradientStop {
        position: 0.95
        color: grad.temperatureLerp(grad.lowTemp, grad.highTemp, 0.95)
    }
    GradientStop {
        position: 1.0
        color: grad.temperatureColor(grad.highTemp)
    }

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
            return colorLerp(Colors.blue, Colors.green, (temp - 32) / 18);

        if (temp <= 65)
            return colorLerp(Colors.green, Colors.yellow, (temp - 50) / 15);

        if (temp <= 80)
            return colorLerp(Colors.yellow, Colors.peach, (temp - 65) / 15);

        if (temp <= 95)
            return colorLerp(Colors.peach, Colors.red, (temp - 80) / 15);

        return Colors.red;
    }

    function temperatureLerp(a, b, t) {
        return temperatureColor(lerp(a, b, t));
    }
}
