/**
 * subpixel_simulator.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Allows control of RGB pixel to control screen color
 *
 */


import QtQuick 2.0

import Tactile.Components 1.0


Rectangle {
    signal done()
    signal color_matched()

    property int elapsed_time: 0
    property int box_height: 400

    property bool animation_enabled: true
    property real tolerance: 0.1

    property alias red: red_pixel.value
    property alias green: green_pixel.value
    property alias blue: blue_pixel.value

    function prompt(text, params) {
        instructions.prompt(text, params)
    }

    property vector3d target_color
    property bool target_enabled: false

    function set_target(r, g, b) {
        target_color = Qt.vector3d(r, g, b);
        target_enabled = true;
    }

    id: bg
    color: Qt.rgba(red, green, blue)

    function update_color() {
        color = Qt.rgba(red, green, blue);

        if (target_enabled && !animation_enabled) {
            var col = Qt.vector3d(red, green, blue);

            // TODO: Use something more color-ful than the Euclidian metric
            if (target_color.fuzzyEquals(col, tolerance)) {
                bg.color_matched();
            }
        }
    }

    onRedChanged: update_color()
    onGreenChanged: update_color()
    onBlueChanged: update_color()

    Rectangle {
        id: subpixel
        color: "#EEEEEE"
        width: 400
        height: 400
        radius: 25
        y: 100
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            property real outer_padding: 0.05
            property int pixel_width: (width - (2 * spacing)) / 3

            spacing: width * 0.02
            height: parent.height * (1 - 2 * outer_padding)
            width: parent.width * (1 - 2 * outer_padding)
            x: parent.width * outer_padding
            y: parent.height * outer_padding

            SubpixelSlider {
                id: red_pixel
                width: parent.pixel_width
                height: parent.height
                radius: subpixel.radius
                onPressed: bg.animation_enabled = false
                pixel_color:  '#F63636'

                animation_enabled: bg.animation_enabled
                animation_min: 0.0
                animation_rising_duration: 5000
                animation_max: 1.0
                animation_falling_duration: 5000
            }

            SubpixelSlider {
                id: green_pixel
                width: parent.pixel_width
                height: parent.height
                radius: subpixel.radius
                onPressed: bg.animation_enabled = false
                pixel_color:  '#9EE044'

                animation_enabled: bg.animation_enabled
                animation_max: 0.3
                animation_rising_duration: 1000
                animation_min: 0.9
                animation_falling_duration: 2000
            }

            SubpixelSlider {
                id: blue_pixel
                width: parent.pixel_width
                height: parent.height
                radius: subpixel.radius
                onPressed: bg.animation_enabled = false
                pixel_color:  '#0E71D4'

                animation_enabled: bg.animation_enabled
                animation_max: 0.7
                animation_rising_duration: 3000
                animation_min: 0.1
                animation_falling_duration: 4000
            }
        }
    }

    InstructionBox {
        id: instructions
        state: 'horizontal-center'
        onClicked: bg.done()
        anchors.top: subpixel.bottom
        anchors.topMargin: 30
    }
}
