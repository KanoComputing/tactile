/**
 * reveal_the_wires.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene which the user wipes to uncover wires
 *
 */


import QtQuick 2.0

import Tactile.Components 1.0


Rectangle {
    signal revealed()
    signal done()

    property int xpos: 200
    property int ypos: 200
    property int radius: 100

    property alias instructions: instructions_text.text
    property alias bg_image: img.source
    property alias enabled: mouse_area.enabled

    function prompt(text, params) {
        desc.prompt(text, params);
    }

    id: scene

    Image {
        id: img
        anchors.centerIn: parent
        visible: false
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        property bool isFirstPaint: true

        renderTarget: Qt.platform.os == 'linux' ?
            Canvas.FramebufferObject : Canvas.Image

        onPaint: {
            if (canvas.isFirstPaint) {
                img.visible = true;

                var ctx = getContext('2d')
                ctx.fillStyle = '#414a50';
                ctx.fillRect(0, 0, scene.width, scene.height);
                ctx.globalCompositeOperation = "destination-out";
                erase_circle();
                canvas.isFirstPaint = false;
                return;
            }

            instructions_text.visible = false;
        }

        function get_percent_filled() {
            var ctx = getContext('2d'),
                imageData = ctx.getImageData(0, 0, scene.width, scene.height),
                len = imageData.data.length,
                acc = 0,
                max = 0;

            for (var i = 3; i < len; i += 1024) {
                if (imageData.data[i]) {
                    acc++;
                }

                max++
            }

            return 100 * acc / max;
        }

        function erase_circle() {
            var ctx = getContext('2d')
            ctx.beginPath();
            ctx.fillStyle = "white";
            ctx.moveTo(xpos, ypos);
            ctx.arc(xpos, ypos, radius, 0, 2.0 * Math.PI, false);
            ctx.lineTo(xpos, ypos);
            ctx.fill();
            canvas.requestPaint()
        }

        function erase_all() {
            var ctx = getContext('2d')
            ctx.fillStyle = "white";
            ctx.fillRect(0, 0, scene.width, scene.height);
            canvas.requestPaint()
        }

        MouseArea {
            id: mouse_area
            enabled: false
            anchors.fill: parent
            onPressed: {
                xpos = mouseX
                ypos = mouseY
                canvas.erase_circle()
            }
            onReleased: {
                if (canvas.get_percent_filled() <= 10) {
                    canvas.erase_all();
                    scene.revealed();
                }
            }
            onMouseXChanged: {
                xpos = mouseX
                ypos = mouseY
                canvas.erase_circle()
            }
            onMouseYChanged: {
                xpos = mouseX
                ypos = mouseY
                canvas.erase_circle()
            }
        }

        InstructionText {
            id: instructions_text
            width: parent.width - (xpos + radius + 50)
            wrapMode: Text.WordWrap
            y: ypos - height / 2
            anchors.right: parent.right
        }

    }

    InstructionBox {
        id: desc
        onClicked: scene.done()
    }
}
