/**
 * terminal.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Emulates a terminal with custom messages and prompts.
 */


import QtQuick 2.3
import QtQuick.Layouts 1.2

import Tactile.Terminal 1.0


Item {
    /**
     * Print a message to the terminal
     */
    signal finished_writing()
    function echo_msg(msg) {
        var component = Qt.createComponent('terminal_text.qml'),
            obj = component.createObject(messages, {
                'anchors.left': messages.left,
                'anchors.right': messages.right
            });

        obj.typewriter(msg.replace(/\n/g, '<br>'));
        obj.finished_writing.connect(terminal.finished_writing);
    }
    function print_msg(msg) {
        var component = Qt.createComponent('terminal_text.qml'),
            obj = component.createObject(messages, {
                'anchors.left': messages.left,
                'anchors.right': messages.right
            });

        obj.text = msg.replace(/\n/g, '<br>');
        terminal.finished_writing();
    }
    function clear_msgs() {
        for (var i = messages.children.length; i > 0; i--) {
            messages.children[i - 1].destroy();
        }
    }


    /**
     * Display a prompt and ask for a message
     */
    function prompt(args) {
        var args = args || {},
            prefix = args.prefix || '',
            prompt_marker = args.prompt_marker || TerminalSettings.prompt_marker,
            completion = args.completion || [],
            component = Qt.createComponent('terminal_prompt.qml'),
            obj = component.createObject(messages, {
                prefix: prefix,
                prompt_marker: prompt_marker,
                completion: completion,
                'anchors.left': messages.left,
                'anchors.right': messages.right
            });
        obj.response.connect(terminal.response);
        prompt_count++;
    }
    property int prompt_count: 0

    /**
     * Triggered when user enters prompt
     */
    signal response(string msg);


    id: terminal

    implicitHeight: messages.implicitHeight


    Column {
        anchors.fill: parent
        spacing: TerminalSettings.font_size
        id: messages
    }
}
