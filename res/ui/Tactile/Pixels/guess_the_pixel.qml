/**
 * guess_the_pixel.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Game to hunt for provided coordinates
 *
 */


import QtQuick 2.0
import QtMultimedia 5.8

import Tactile.Components 1.0
import Tactile.Pixels 1.0


Rectangle {
    signal done()
    signal next()
    signal target_hit()

    function prompt(text, params) {
        instructions.prompt(text, params)
    }

    function fade_color() {
        color_fade.running = true;
    }

    property bool transitioning: false
    function transition() {
        transitioning = true;
    }

    id: bg

    property int target_x: -1
    property int target_y: -1
    property int tolerance: 100

    function reset_target(x, y, hint) {
        target_x = x;
        target_y = y;

        if (hint !== undefined) {
            // Draw circle
        }
    }

    function distance(x1, y1, x2, y2){
        return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    }

    Image {
        id: bw_ruler
        source: "blank_ruler.png"
        anchors.centerIn: parent
    }

    Image {
        id: color_ruler
        source: "rainbow.png"
        anchors.centerIn: parent
        z: 1
        transform: Scale {
            id: img_transform
            origin.x: target_x
            origin.y: target_y

        }

        NumberAnimation on opacity {
            id: color_fade
            running: false
            from: 1
            to: 0
        }

        SequentialAnimation {
            running: bg.transitioning

            ParallelAnimation {
                NumberAnimation {
                    target: img_transform
                    property: 'xScale'
                    from: 1
                    to: 5
                }
                NumberAnimation {
                    target: img_transform
                    property: 'yScale'
                    from: 1
                    to: 5
                }
            }
            ScriptAction {
                script: bg.done()
            }
        }
    }

    SoundEffect {
        id: sound_success
        source: "challenge_complete.wav"
    }
    SoundEffect {
        id: sound_failure
        source: "ungrab.wav"
    }

    Component {
        id: pixel
        Pixel {
            z: 1
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 1
        touchPoints: [
            TouchPoint { id: touch1 }
        ]
        onPressed: {
            if (target_x < 0 && target_y < 0) {
                return;
            }

            var dist = distance(touch1.x, touch1.y, target_x, target_y);

            if (dist < bg.tolerance) {
                pixel.createObject(bg, {
                    'x': target_x,
                    'y': target_y
                });
                target_x = -1;
                target_y = -1;

                sound_success.play();
                bg.target_hit();
            } else {
                sound_failure.play();
            }
        }
    }

    InstructionBox {
        id: instructions
        onClicked: bg.next()
    }
}
