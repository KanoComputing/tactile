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

    function prompt(text) {
        desc.visible = !!text;
        prompt_text.text = text;
    }

    id: scene

    Image {
        id: img
        anchors.centerIn: parent
        visible: false
    }

    Canvas {
        id: myCanvas
        anchors.fill: parent

        property bool isFirstPaint: true

        renderTarget: Qt.platform.os == 'linux' ?
            Canvas.FramebufferObject : Canvas.Image

        onPaint: {
            if (myCanvas.isFirstPaint) {
                img.visible = true;

                var ctx = getContext('2d')
                ctx.fillStyle = '#414a50';
                ctx.fillRect(0, 0, scene.width, scene.height);
                ctx.globalCompositeOperation = "destination-out";
                eraseCircle();
                myCanvas.isFirstPaint = false;
                return;
            }

            instructions_text.visible = false;
        }

        function getPercentFilled() {
            var ctx = getContext('2d'),
                imageData = ctx.getImageData(0, 0, scene.width, scene.height),
                len = imageData.data.length,
                acc = 0;

            for (var i = 3; i < len; i += 1024) {
                acc = acc + imageData.data[i];
            }

            return acc;
        }

        function eraseCircle() {
            var ctx = getContext('2d')
            ctx.beginPath();
            ctx.fillStyle = "white";
            ctx.moveTo(xpos, ypos);
            ctx.arc(xpos, ypos, radius, 0, 2.0 * Math.PI, false);
            ctx.lineTo(xpos, ypos);
            ctx.fill();
            myCanvas.requestPaint()
        }

        MouseArea {
            id: mouse_area
            enabled: false
            anchors.fill: parent
            onPressed: {
                xpos = mouseX
                ypos = mouseY
                myCanvas.eraseCircle()
            }
            onReleased: {
                if (myCanvas.getPercentFilled() === 0) {
                    scene.revealed();
                }
            }
            onMouseXChanged: {
                xpos = mouseX
                ypos = mouseY
                myCanvas.eraseCircle()
            }
            onMouseYChanged: {
                xpos = mouseX
                ypos = mouseY
                myCanvas.eraseCircle()
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

    Item {
        id: desc
        visible: false
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30

        width: 300

        InstructionText {
            id: prompt_text
            text: "Your screen is filled with invisible wires made " +
                  "of Indium Oxide. Ready to see what the do?"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: next_btn.top
            anchors.bottomMargin: 30
        }

        NextButton {
            id: next_btn
            onClicked: scene.done()
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            text: "Next"
        }
    }
}
