/**
 * touch_screen_scene.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene with a terminal and touch screen animation.
 */


import QtQuick 2.9

import Tactile.Terminal 1.0
import Tactile.Touch 1.0


Item {
    id: root

    property alias prompt_count: sceneTerminal.prompt_count

    signal touched()
    signal response()

    // Private members.
    property int _overscanValue


    TouchScreenDigitizer {
        id: digitizer

        anchors.fill: parent
    }

    Terminal {
        id: sceneTerminal

        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.margins: _overscanValue
    }

    Component.onCompleted: {
        // FIXME: Hacky way of being able to have some scene components fill
        // to the entire width of the screen without the master padding.
        _overscanValue = parent.overscan_value;
        parent.overscan_value = 0;

        digitizer.touched.connect(touched);
        sceneTerminal.response.connect(response);
    }

    function restorePadding() {
        parent.overscan_value = _overscanValue;
    }

    function prompt(args) {
        sceneTerminal.prompt(args);
    }

    function print_msg(msg) {
        sceneTerminal.print_msg(msg);
    }

    function echo_msg(msg) {
        sceneTerminal.echo_msg(msg);
    }

    function clear_msgs() {
        sceneTerminal.clear_msgs();
    }
}
