/**
 * matrix.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Matrix like animation on QML. Most of the rendering code comes from
 * https://github.com/KanoComputing/kano-matrix
 */


import QtQuick 2.3

/* Javascript modules that do the graphic rendering */
import 'drop.js' as DropJS
import 'matrix.js' as MatrixJS


Rectangle {
    id: matrix_box

    /* This timer is used to simulate setInterval() available on web browsers */
    Timer {
        id: paintTimer
        interval: 50
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            canvas.requestPaint()
        }
    }

    Timer {
        id: animationTimer
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            canvas.fadeout = true;
        }
    }

    /* indicates completion of the animation, set by start(duration) */
    signal done()

    /* main function to start the animation, will signal "done" on completion */
    function start(duration) {

        /* start the timer for the overall animation time - in msecs */
        animationTimer.interval = duration
        animationTimer.start()

        /* start the timer that paints continously and causes the animation */
        paintTimer.start()
    }

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height

        property int numberOfDrops: 0
        property int fontSize: 24
        property var drops: []
        property bool fadeout: false
        property int fadeout_events: 10 /* number of paints to fade away the animation */

        onPaint: {
            var ctx = getContext("2d");

            /* create the drops the first time */
            if (numberOfDrops === 0) {
                numberOfDrops = canvas.width / fontSize;
                for(var x = 0; x < numberOfDrops; x++) {
                   drops.push(new DropJS.Drop(x, canvas, ctx, fontSize));
                }

                /* set the canvas font face size and family name */
                if (Qt.platform.os == "linux") {
                    ctx.font = fontSize + "px Monospace";
                }
                else {
                    ctx.font = fontSize + "px Courier";
                }
            }

            MatrixJS.paint_matrix(ctx, canvas, drops, fadeout);

            /* to terminate the animation, remove each drop one at a time */
            if (fadeout === true) {
               if (drops.length) {
                  drops.pop();
               }
               else if (!fadeout_events--) {
                  paintTimer.running = false;
                  done();
               }

            }
        }
    }
}
