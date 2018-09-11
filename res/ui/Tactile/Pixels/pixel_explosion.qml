/**
 * pixel_explosion.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Pixel erupter
 *
 */


import QtQuick 2.0
import QtQuick.Particles 2.0

import Tactile.Pixels 1.0


ParticleSystem {
    signal exploded()

    function explode(count, x, y) {
        emitter.burst(count, x, y);
        particle_timer.running = true;
    }

    id: particle_sys

    anchors.top: parent.top
    anchors.left: parent.left
    height: 1000
    width: 1000

    running: true

    Emitter {
        id: emitter
        x: 500
        y: 400
        lifeSpan: 2000
        size: 100
        emitRate: 0
        enabled: true
        velocity: PointDirection {
            x: 0
            xVariation: 300
            y: 0
            yVariation: 300
        }
    }

    ItemParticle {
        delegate: Pixel {
        }
    }

    Timer {
        id: particle_timer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            particle_sys.running = false;
            particle_sys.exploded();
        }
    }

}
