/**
 * terminal_header.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Component which echoes instructional messages like a terminal and then
 * exposes the task for the user.
 *
 */


import QtQuick 2.0
import QtGraphicalEffects 1.0

import Tactile.Terminal 1.0


Item {
    default property alias data: content.data
    property int content_height
    property alias prompt_count: terminal.prompt_count
    signal response(string msg)
    signal finished_writing()

    anchors.fill: parent
    function echo_msg(msg) {
        if (main.visible) {
            tail_term.echo_msg(msg)
        } else {
            terminal.echo_msg(msg)
        }
    }
    function prompt(args) {
        if (main.visible) {
            tail_term.prompt(args)
        } else {
            terminal.prompt(args)
        }
    }

    id: wrapper

    Terminal {
        id: terminal

        anchors.fill: undefined
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 100

        onFinished_writing: {
            main.visible = true
            wrapper.finished_writing()
        }
        onResponse: wrapper.response(msg)
    }

    Item {
        id: main

        anchors.top: terminal.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: false

        Item {
            id: content
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: tail_term.implicitHeight === 0 ?
                main.height : Math.min(content_height, main.height)
        }

        Terminal {
            id: tail_term
            anchors.top: content.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: main.bottom
            anchors.topMargin: 30
            onFinished_writing: wrapper.finished_writing()
            onResponse: wrapper.response(msg)
        }
    }

}
