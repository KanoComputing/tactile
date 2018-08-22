/**
 * target.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * The item which the user must navigate to with the mouse to
 * complete mouse onboarding.
 */


import QtQuick 2.3
import QtQuick.Controls 1.4

import Tactile.Animation 1.0
import Tactile.Mouse 1.0
import Tactile.Terminal 1.0


AsciiAnimation {
    id: target

    signal clicked(var mouse)
    signal entered()
    signal exploded()
    property string tooltip_text: ''

    color: 'black'

    function hit() {
        target.finished_playing.connect(function() {
            target.destroy();
            target.exploded();
        });

        tooltip_loader.sourceComponent = undefined
        target.play();
    }

    MouseArea {
        id: mousearea
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        hoverEnabled: true
    }

    Loader {
        id: tooltip_loader

        anchors.bottom: target.bottom
        anchors.horizontalCenter: target.horizontalCenter

        SequentialAnimation on anchors.margins {
            loops: Animation.Infinite
            NumberAnimation {
                from: 25
                to: 35
                duration: 500
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                to: 25
                duration: 500
                easing.type: Easing.InOutSine
            }
        }

        Component {
            id: tooltip
            Tooltip {
                text: tooltip_text
            }
        }

        sourceComponent: tooltip_text ? tooltip : undefined
    }

    Component.onCompleted: {
        mousearea.clicked.connect(target.clicked);
        mousearea.entered.connect(target.entered);
    }
}
