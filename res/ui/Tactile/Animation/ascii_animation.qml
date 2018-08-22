/**
 * ascii_animation.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene to play ASCII animations.
 */


import QtQuick 2.3

import Tactile.Terminal 1.0


Rectangle {
    signal finished_playing

    function play(conf) {
        var conf = conf || {},
            anim_frames = conf['frames'] || frames,
            desired_fps = conf['fps'] || fps,
            col_count = conf['columns'] || columns,
            row_count = conf['rows'] || rows,
            loop_count = conf['loops'] || loops,
            from = conf['from'] || 0,
            to = conf['to'] || (anim_frames.length - 1);

        if (anim_frames.length === 0) {
            return;
        }

        frames = anim_frames;
        loops = loop_count;
        fps = desired_fps = conf['fps'] || fps,
        columns = col_count = conf['columns'] || columns,
        rows = row_count = conf['rows'] || rows,

        frame_idx_anim.from = from;
        frame_idx_anim.to = to;
        frame_idx_anim.duration = (to - from) * frame_time;
        frame_idx_anim.start();
    }

    property int fps: 10
    property var frames: []
    property int columns: 75
    property int rows: 30
    property alias loops: frame_idx_anim.loops

    width: parent.width
    height: text.font.pixelSize * rows

    readonly property int frame_time: 1000 / fps
    property int current_frame_idx: 0
    property real font_scale_factor: 1.5

    TerminalFont {
        id: text
        anchors.fill: parent
        font.pixelSize: font_scale_factor * parent.width / columns
        text: frames[current_frame_idx];
    }

    NumberAnimation on current_frame_idx {
        id: frame_idx_anim
        from: 0
        running: false
        loops: 1
        onStopped: finished_playing()
    }
}
