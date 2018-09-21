/**
 * pixel.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Visualisation of a single pixel which cycles through colors
 *
 */


import QtQuick 2.0


Rectangle {
    property real hue: 1
    property int size: 2

    SequentialAnimation on hue {
        loops: Animation.Infinite
        running: true
        PropertyAnimation {
            to: 0.0
            duration: 5000
        }
        PropertyAnimation {
            to: 1.0
            duration: 5000
        }
    }
    color: Qt.hsva(hue, 1, 1)
    width: size
    height: size
}
