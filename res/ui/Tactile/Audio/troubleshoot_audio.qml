/**
 * troubleshoot_audio.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * A scene to set the correct audio output.
 */


import QtQuick 2.3

import Tactile.Audio 1.0


PlaySound {
    states: [
        State {
            name: 'ck2_pro'
            PropertyChanges {
                target: img
                source: 'ck2_pro.gif'
            }
        },
        State {
            name: 'ck2_lite_hdmi'
            PropertyChanges {
                target: img
                source: 'ck2_lite_hdmi.gif'
            }
        },
        State {
            name: 'ck2_lite_jack'
            PropertyChanges {
                target: img
                source: 'ck2_lite_jack.gif'
            }
        },
        State {
            name: 'formerly_ck2_lite'
            PropertyChanges {
                target: img
                source: 'rpi_jack.gif'
            }
        },
        State {
            name: 'legacy_kit'
            PropertyChanges {
                target: img
                source: 'legacy_kit.png'
            }
        }
    ]

    function setup_ck2_pro_troubleshoot() {
        state = 'ck2_pro'
    }
    function setup_ck2_lite_hdmi_troubleshoot() {
        state = 'ck2_lite_hdmi'
    }
    function setup_ck2_lite_jack_troubleshoot() {
        state = 'ck2_lite_jack'
    }
    function setup_formerly_ck2_lite_troubleshoot() {
        state = 'formerly_ck2_lite'
    }
    function setup_legacy_kit_troubleshoot() {
        state = 'legacy_kit'
    }


    header: AnimatedImage {
        id: img
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
