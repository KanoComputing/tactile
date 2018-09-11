/**
 * touch_a_grid.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Visualisation of the charges on the touchscreen wire grid
 *
 */


import QtQuick 2.0
import QtQuick.Particles 2.0

import Tactile.Components 1.0
import Tactile.Wires 1.0


Item {
    signal done()
    signal touch()

    function prompt(text) {
        instructions_text.text = text || '';
    }

    id: scene
    height: 1280  // FIXME: Hardcoded otherwise height is 0 and can't be used

    Image {
        id: img
        source: "touchscreen.png"
        anchors.fill: parent
    }

    InstructionText {
        id: instructions_text
        width: parent.width / 2
        wrapMode: Text.WordWrap
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
        z: 1
    }

    MultiPointTouchArea {
        property int touches: 0
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 1
        touchPoints: [
            TouchPoint { id: touch1 }
        ]
        onPressed: scene.touch()
    }

    function get_charge_count() {
        var rand = Math.random(),
            threshold = 0.6,
            max_particles = 3;

        if (rand < threshold) {
            return 0;
        }

        // Normalise
        rand = (rand - threshold) / (1 - threshold);

        return Math.round(rand * max_particles);
    }

    Repeater {
        id: horizontal_charges
        model: 25

        Repeater {
            id: h_line_charges
            model: get_charge_count()
            property int row_y: index * scene.height / horizontal_charges.count

            Charge {
                is_horizontal: true
                min_pos: Math.random() > 0.5 ? 0 : scene.width
                max_pos: min_pos == 0 ? scene.width : 0

                id: charge
                x: Math.round(Math.random() * scene.width)
                y: h_line_charges.row_y
            }
        }
    }

    Repeater {
        id: vertical_charges
        model: 40

        Repeater {
            id: v_line_charges
            model: get_charge_count()
            property int col_x: index * scene.width / vertical_charges.count

            Charge {
                is_horizontal: false
                min_pos: Math.random() > 0.5 ? 0 : scene.height
                max_pos: min_pos == 0 ? scene.height : 0

                id: charge
                x: v_line_charges.col_x
                y: Math.round(Math.random() * scene.height)
            }
        }
    }

    ParticleSystem {
        anchors.fill: parent
        running: true

        Repeater {
            model: 4

            Emitter {
                property real angle: index * Math.PI / 2
                property int x_component: Math.sin(angle)
                property int y_component: Math.cos(angle)

                x: touch1.x
                y: touch1.y
                enabled: touch1.pressed
                lifeSpan: 750
                emitRate: 5
                size: 60
                velocity: PointDirection {
                    x: 150 * x_component
                    xVariation: 100 * x_component
                    y: 100 * y_component
                    yVariation: 100 * y_component
                }
            }
        }

        ImageParticle {
            source: "charge.png"
            alpha: 1.0
        }
    }

}
