/**
 * pixel_divider.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Allows the user to divide a pixel until they see the underlying image
 *
 */


import QtQuick 2.0

import Tactile.Components 1.0


Item {
    signal done()
    signal touch()

    id: scene

    function prompt(text, params) {
        instructions.prompt(text, params)
    }


    InstructionBox {
        id: instructions
        state: 'top-left'
    }

    Image {
            id: img
            source: 'map.jpg'
            visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            effect.pixelation = Math.max(effect.pixelation /= 2, 1);
            scene.touch();
        }
    }

    ShaderEffect {
        property variant src: img
        readonly property int max_pixelation: 8192
        // Higher is more pixelated (1 = no pixelation)
        property int pixelation: max_pixelation
        // Coordinates are between 0 and 1 so the pixelation must be scaled
        property real res: pixelation / max_pixelation

        onPixelationChanged: {
            if (pixelation <= 8) {
                scene.done();
            }
        }

        id: effect
        anchors.fill: parent

        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }
        "
        fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            uniform float res;
            void main() {
                // Mid-point of the box in the grid of dimension res x res
                float u = (0.5 + floor(coord.x / res)) * res;
                float v = (0.5 + floor(coord.y / res)) * res;

                gl_FragColor = texture2D(src, vec2(u, v));
            }
        "
    }
}
