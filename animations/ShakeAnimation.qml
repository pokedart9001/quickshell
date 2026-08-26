import QtQuick

SequentialAnimation {
    id: animation

    required property QtObject target
    required property string property

    property real intensity: 1

    NumberAnimation {
        target: animation.target
        property: animation.property
        to: -8 * animation.intensity
        duration: 50
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 7 * animation.intensity
        duration: 70
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: -6 * animation.intensity
        duration: 60
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 5 * animation.intensity
        duration: 50
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: -3 * animation.intensity
        duration: 45
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 1 * animation.intensity
        duration: 40
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 0
        duration: 100
    }
}
