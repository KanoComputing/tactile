/**
 * touch_a_wire.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Visualiser for the charges on a single touch screen wire
 *
 */


import QtQuick 2.0
import QtQuick.Particles 2.0

import Tactile.Components 1.0
import Tactile.Wires 1.0


Item {
    signal done()
    signal charges_emitted()
    signal touched()

    id: bg

    property int wire_y: 343
    property int max_touches: 5

    function prompt(text, params) {
        instructions.prompt(text, params)
    }

    Image {
        source: "wire.png"
        anchors.centerIn: parent
    }

    MultiPointTouchArea {
        property int touches: 0
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 1
        touchPoints: [
            TouchPoint { id: touch1 }
        ]
        onPressed: {
            bg.touched();
            touches++;

            if (touches > bg.max_touches) {
                bg.charges_emitted();
            }
        }
    }


    Repeater {
        id: charge_repeater
        model: 8
        property int size: 30

        Charge {
            is_horizontal: true
            property int start_x: Math.round(Math.random() * bg.width)
            size: charge_repeater.size
            min_pos: Math.random() > 0.5 ? 0 : bg.width
            max_pos: min_pos == 0 ? bg.width : 0

            x: start_x
            y: wire_y + height
        }
    }

    ParticleSystem {
        id: sys
        width: parent.width
        height: parent.height
        running: true

        Emitter {
            id: emit_right
            // Move emitter out from under finger (assume fingers are 30px wide)
            x: touch1.x + 15
            y: wire_y + 1.5 * size
            enabled: touch1.pressed
            lifeSpan: 750
            emitRate: 5
            size: charge_repeater.size
            velocity: PointDirection {
                x: 150
                xVariation: 100
            }
        }
        Emitter {
            id: emit_left
            // Move emitter out from under finger (assume fingers are 30px wide)
            x: touch1.x + 15
            y: wire_y + 1.5 * size
            enabled: touch1.pressed
            lifeSpan: 750
            emitRate: 5
            size: charge_repeater.size
            velocity: PointDirection {
                x: -150
                xVariation: 100
            }
        }

        ImageParticle {
            source: 'charge-positive.png'
            alpha: 1.0
        }
    }

    InstructionBox {
        id: instructions
        state: 'top-left'
        onClicked: bg.done()
    }

}
