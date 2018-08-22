/**
 * visualise_microphone.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
 *
 * This is a scene in the Tactile flow. It comes up if the USB microphone
 * is plugged in and shows a visualisation of the volume it captures.
 */


import QtQuick 2.3
import QtQml.Models 2.2

import Kano.Peripherals 1.0

import Tactile.Terminal 1.0


Item {
    id: root

    property double amplify: 6.0
    property int sampleCount: 25
    property int barWidth: 24
    property bool isAvailable: false

    signal finishedSetup()

    // Duplicated
    property alias prompt_count: sceneTerminal.prompt_count

    signal response()


    Microphone {
        id: microphone

        onVolumeChanged: {
            volumeSamples.remove(0, 1);
            volumeSamples.append(newVolumeSample(microphone.volume));
        }

        Component.onCompleted: {
            microphone.initialise();
            microphone.start();
        }
    }

    ListModel {
        id: volumeSamples

        // Initialise the ListModel with 0 values.
        Component.onCompleted: {
            for (var i = 1; i <= sampleCount; i++) {
                append(newVolumeSample(0.0));
            }
        }
    }

    Terminal {
        id: sceneTerminal

        anchors.top: root.top
        anchors.left: root.left
        anchors.right: root.right

        Component.onCompleted: {
            sceneTerminal.response.connect(root.response);
        }
    }

    Row {
        id: visualisation

        visible: false
        spacing: (root.width - sampleCount * barWidth) / sampleCount
        height: root.height * 0.70

        anchors.top: sceneTerminal.top
        anchors.left: root.left
        anchors.right: root.right
        anchors.bottom: root.bottom
        anchors.topMargin: 80

        Repeater {
            model: volumeSamples

            AsciiRectangle {
                width: barWidth
                height: visualisation.height * amplifyVolume(volume) + 1
                y: (visualisation.height - height) / 2
            }
        }
    }

    function newVolumeSample(volume) {
        return {
            "volume": volume
        }
    }

    function amplifyVolume(volume) {
        return (tanh(25 * volume - 2) + 0.964) / 2.0
    }

    function tanh(x) {
        return (Math.exp(2 * x) - 1) / (Math.exp(2 * x) + 1)
    }

    // TODO: On RPi, the QAudioInput does not emit notify as you'd expect.
    //       Calling processAudio which seems to force it to start.
    Timer {
        id: clock
        interval: 1000  // ms
        running: true
        repeat: false
        onTriggered: {
            microphone.processAudio();
            root.isAvailable = microphone.isAvailable();
            if (root.isAvailable)
                visualisation.visible = true;
            finishedSetup();
        }
    }

    /*
     * Duplicated
     */

    function prompt(args) {
        sceneTerminal.prompt(args);
    }

    function echo_msg(msg) {
        sceneTerminal.echo_msg(msg);
    }
}
