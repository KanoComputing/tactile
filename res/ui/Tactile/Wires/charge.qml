/**
 * charge.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Visualisation of a charge
 *
 */


import QtQuick 2.0


Item {
    property int is_positive: Math.random() > 0.5
    property bool is_horizontal: true
    property int min_pos
    property int max_pos
    property int size: 30

    id: charge

    width: size
    height: size

    Image {
        source: is_positive ? 'charge-positive.png' : 'charge-negative.png'
        anchors.fill: parent
    }

    SequentialAnimation on x {
        running: is_horizontal
        loops: Animation.Infinite
        PropertyAnimation {
            to: charge.min_pos
            duration: 3000 + 2000 * Math.random()
        }
        PropertyAnimation {
            to: charge.max_pos
            duration: 3000 + 2000 * Math.random()
        }
    }

    SequentialAnimation on y {
        running: !is_horizontal
        loops: Animation.Infinite
        PropertyAnimation {
            to: charge.min_pos
            duration: 3000 + 2000 * Math.random()
        }
        PropertyAnimation {
            to: charge.max_pos
            duration: 3000 + 2000 * Math.random()
        }
    }
}
