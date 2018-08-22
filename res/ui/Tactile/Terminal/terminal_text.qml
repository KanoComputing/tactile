/**
 * terminal_text.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Text element to use in the terminal.
 */


import QtQuick 2.3
import QtQuick.Controls 1.4

import Tactile.Terminal 1.0


TerminalFont {
    signal finished_writing()

    property string echo_text: ''
    property int print_speed: 45
    property int displayed_chars: 0

    id: terminal_text
    text: echo_text.substr(0, terminal_text.char_map[displayed_chars])
    wrapMode: Text.WordWrap

    width: parent.width

    function typewriter(msg) {
        echo_text = msg;
    }

    function strip_markup(msg) {
        return msg.replace(/<[^>]+>/g, '');
    }


    /**
     * Maps the displayed character indexes to their actual position in the
     * marked-up string. The final character is mapped to the end of the
     * original string.
     *
     * E.g. str = 'a<br>b' would produce the map, m
     *      m[0] = 0
     *      m[1] = 5
     *      m[1] = 6
     *
     *      str = '<b>a</b>' would produce the map, m
     *      m[0] = 3
     *      m[0] = 8
     */
    function create_char_map(msg) {
        var map = [],
            len = msg.length,
            in_tag = false,
            i,
            ch;

        for (i = 0; i < len; i++) {
            ch = msg[i];

            if (in_tag) {
                if (ch === '>') {
                    in_tag = false;
                }

                continue;
            }

            if (ch === '<') {
                in_tag = true
                continue;
            }

            map.push(i);
        }

        // Mark the end of the string
        map.push(len);

        return map;
    }
    property var char_map: create_char_map(echo_text)


    PropertyAnimation on displayed_chars {
        id: writing_animation
        running: false
        from: 0
        onStopped: terminal_text.finished_writing();
    }

    onEcho_textChanged: {
        var len = strip_markup(echo_text).length;
        writing_animation.to = len;
        writing_animation.duration = len * print_speed;

        writing_animation.start();
    }
}
