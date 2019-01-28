/**
 * click.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene to practice clicking.
 */


import QtQuick 2.3
// import Multimedia 5.8

import Tactile.Mouse 1.0


MouseScene {
    id: screen

    tutorial_animation: 'keyboard_click.gif'

    function new_target(x, y, conf) {
        var target = screen.create_target(x, y, conf);
        target.clicked.connect(function(mouse) {
            // clicked_sound.play();
            target.hit();
        });
        target.exploded.connect(function() {
            screen.target_hit();
        });
    }

    /*
    Audio {
        id: clicked_sound
        source: 'pop.wav'
    }
    */
}
