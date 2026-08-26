import QtQuick

SequentialAnimation {
    id: animation

    required property QtObject target
    required property string property

    NumberAnimation {
        target: animation.target
        property: animation.property
        to: -8
        duration: 50
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 7
        duration: 70
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: -6
        duration: 60
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 5
        duration: 50
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: -3
        duration: 45
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 1
        duration: 40
    }
    NumberAnimation {
        target: animation.target
        property: animation.property
        to: 0
        duration: 100
    }
}
