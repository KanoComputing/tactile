/**
 * animated_image.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene to play GIF animations.
 */


import QtQuick 2.3


Item {
    id: root
    signal animation_finished()

    function play(conf) {
        animation.source = conf.source;
    }

    AnimatedImage {
        id: animation
        cache: false
        anchors.centerIn: parent
        onCurrentFrameChanged: {
            if (currentFrame >= frameCount - 1) {
                root.animation_finished();
            }
        }
        asynchronous: true
    }
}
