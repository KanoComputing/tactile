/**
 * tooltip.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * The item which the user must navigate to with the mouse to
 * complete mouse onboarding.
 */


import QtQuick 2.0

import Tactile.Terminal 1.0


Item {
    property alias text: txt.text
    property url img
    property int max_width: 260

    id: tooltip
    implicitWidth: bubble.width
    implicitHeight: pointer.height + bubble.height

    Rectangle {
        id: pointer
        color: bubble.color

        // Anchors applied to pre-transform sizing
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.horizontalCenter: bubble.horizontalCenter

        transform: [
            Rotation {
                origin.x: pointer.width / 2
                origin.y: pointer.height / 2
                angle: 45
            },
            Scale {
                origin.x: pointer.width / 2
                origin.y: pointer.height / 2
                xScale: 1
                yScale: 1
            }
        ]
    }

    Rectangle {
        id: bubble

        property int padding: 20
        color: 'white'
        radius: 10
        anchors.top: pointer.verticalCenter

        implicitHeight: bubble_contents.height + 2 * padding
        implicitWidth: bubble_contents.width + 2 * padding

        Item {
            id: bubble_contents

            implicitHeight: txt.height
            implicitWidth: tip_img.width + txt.width

            anchors.centerIn: parent

            AnimatedImage {
                id: tip_img

                source: img
                fillMode: Image.PreserveAspectFit

                anchors.top: txt.top
                anchors.bottom: txt.bottom
                anchors.left: parent.left
            }

            TerminalFont {
                id: txt

                color: 'black'
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: Math.min(
                    implicitWidth,
                    max_width - 2 * bubble.padding
                )
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
