import QtQuick

SequentialAnimation {
    id: animation

    required property Item opacityTarget
    required property Item propertyChangeTarget
    required property string propertyToChange

    property int fadeOutDuration: 50
    property int fadeInDuration: 500

    NumberAnimation {
        target: animation.opacityTarget
        property: "opacity"
        from: 1
        to: 0
        duration: animation.fadeOutDuration
        easing.type: Easing.InOutQuint
    }

    PropertyAction {
        target: animation.propertyChangeTarget
        property: animation.propertyToChange
    }

    NumberAnimation {
        target: animation.opacityTarget
        property: "opacity"
        from: 0
        to: 1
        duration: animation.fadeInDuration
        easing.type: Easing.InOutQuint
    }
}
