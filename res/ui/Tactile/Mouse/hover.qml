/**
 * hover.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene to show how to move the mouse.
 */


import QtQuick 2.3

import Tactile.Mouse 1.0


MouseScene {
    id: screen

    tutorial_animation: 'keyboard_click.gif'

    function new_target() {
        var target = screen.create_target();
        target.entered.connect(function() {
            target.hit();
            screen.target_hit();
        });
    }
}
