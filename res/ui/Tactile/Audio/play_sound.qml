/**
 * play_sound.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * A scene with a terminal that can play sounds.
 */


import QtQuick 2.3
// import Multimedia 5.8

import Tactile.Terminal 1.0


Item {
    signal finished_playing()
    signal finished_writing()
    signal response(string msg)
    function play_beep() {
        // beep.source = 'beep.wav'
        // beep.play();
    }
    function play_hello() {
        // beep.source = 'hello.wav'
        // beep.play();
    }
    function echo_msg(msg) {
        terminal.echo_msg(msg);
    }
    function prompt(args) {
        terminal.prompt(args);
    }


    property alias header: header_container.data
    property alias prompt_count: terminal.prompt_count

    id: play_sound

    Item {
        id: header_container
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        height: childrenRect.height
        width: childrenRect.width
    }

    Terminal {
        id: terminal

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: header_container.left

        Component.onCompleted: {
            terminal.response.connect(play_sound.response);
            terminal.finished_writing.connect(play_sound.finished_writing);
        }
    }

    /*
    Audio {
        id: beep
        source: 'beep.wav'
        onStopped: play_sound.finished_playing()
    }
    */
}
