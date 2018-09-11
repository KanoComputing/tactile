/**
 * subpixel_slider.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Slider to control a single color pixel
 *
 */


import QtQuick 2.0


Rectangle {
    signal pressed()

    property real value
    property real padding
    property color pixel_color

    property alias animation_enabled: value_animation.running
    property real animation_max
    property real animation_min
    property int animation_rising_duration
    property int animation_falling_duration

    id: subpixel_slider

    width: (parent.width - (2 * parent.width * padding)) / 3
    height: parent.height
    color: "black"
    radius: parent.radius


    SequentialAnimation on value {
        id: value_animation
        loops: Animation.Infinite
        PropertyAnimation {
            easing.type: Easing.OutBounce
            to: animation_max
            duration: animation_rising_duration
        }
        PropertyAnimation {
            easing.type: Easing.OutBounce
            to: animation_min
            duration: animation_falling_duration
        }
    }

    MultiPointTouchArea {
        onPressed: subpixel_slider.pressed()
        touchPoints: [
            TouchPoint { id: touch_point }
        ]
        anchors.fill: parent
        onTouchUpdated: {
            subpixel_slider.value = 1 - Math.min(
                1, Math.max(0, touch_point.y) / parent.height
            )
        }
    }

    Rectangle {
        width: parent.width
        height: subpixel_slider.value * parent.height
        color: subpixel_slider.pixel_color
        anchors.bottom: parent.bottom
        radius: parent.radius
    }
}
