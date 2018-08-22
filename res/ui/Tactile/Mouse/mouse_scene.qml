/**
 * mouse_scene.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Base scene upon which mouse scenes are based.
 */


import QtQuick 2.9
import QtQuick.Controls 1.4

import Tactile.Terminal 1.0


TerminalHeader {
    property alias tutorial_animation: animation.source
    property alias touch_enabled: toucharea.mouseEnabled
    signal target_hit()

    function create_target(x, y, conf) {
        var component = Qt.createComponent('target.qml'),
            conf = conf || {},
            tooltip_text = conf['tooltip_text'] || '',
            animation = conf['animation'] || {},
            target_width = parent.width / 3;

        return component.createObject(target_board, {
            x: x,
            y: y,
            width: target_width,
            height: target_width,
            tooltip_text: tooltip_text,
            frames: animation.frames,
            columns: animation.columns,
            rows: animation.rows,
            fps: animation.fps
        });
    }

    id: screen

    Item {
        id: target_board
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: animation.top
        anchors.margins: 150
    }

    AnimatedImage {
        id: animation
        height: 140
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        cache: false
    }

    // Grab touch events to prevent touch triggering the targets
    MultiPointTouchArea {
        id: toucharea
        mouseEnabled: false
        anchors.fill: parent
        z: 100
    }
}
