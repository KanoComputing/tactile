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

    function prompt(text, params) {
        instructions.prompt(text, params)
    }

    property int charge_size: 30

    id: scene
    height: 1280  // FIXME: Hardcoded otherwise height is 0 and can't be used

    Image {
        id: img
        source: "touchscreen.png"
        anchors.fill: parent
    }

    InstructionBox {
        id: instructions
        state: 'top-left'
        onClicked: scene.done()
    }

    MultiPointTouchArea {
        id: touch_area
        property int touches: 0
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 10
        touchPoints: [
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {},
            TouchPoint {}
        ]

        property list<TouchPoint> current_touch_points

        onTouchUpdated: {
            if (current_touch_points.length === touchPoints.length) {
                // current_touch_points already contains pointers to all
                // the points in the update event so don't update to
                // avoid triggering a refresh
                return;
            }

            current_touch_points = touchPoints;
        }

        onPressed: scene.touch();
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
                size: scene.charge_size

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
                size: scene.charge_size

                x: v_line_charges.col_x
                y: Math.round(Math.random() * scene.height)
            }
        }
    }

    ParticleSystem {
        anchors.fill: parent
        running: true

        Repeater {
            id: touch_emitters
            model: touch_area.current_touch_points

            Repeater {
                model: 2
                property int touch_index: index
                property TouchPoint touch_point: touch_area.current_touch_points[index]

                Emitter {
                    property real angle: index * Math.PI / 2
                    property int x_component: Math.sin(angle)
                    property int y_component: Math.cos(angle)

                    x: touch_point ? touch_point.x : 0
                    y: touch_point ? touch_point.y : 0
                    enabled: touch_point ? touch_point.pressed : false
                    lifeSpan: 750
                    emitRate: 4
                    size: scene.charge_size
                    velocity: PointDirection {
                        x: 0
                        xVariation: 300 * x_component
                        y: 0
                        yVariation: 300 * y_component
                    }
                }
            }
        }

        ImageParticle {
            source: 'charge-positive.png'
            alpha: 1.0
        }
    }

}
