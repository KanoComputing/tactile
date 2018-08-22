/**
 * ascii_rectangle.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
 *
 * This component can be used to create rectangles out of an ASCII
 * character set.
 */


import QtQuick 2.3

import Tactile.Terminal 1.0


Item {
    id: root

    property string charSet: "01"


    Grid {
        id: asciiGrid

        anchors.centerIn: root

        property int rowsOfChars: root.height / TerminalSettings.font_size

        columns: Math.ceil(root.width / TerminalSettings.font_size)
        rows: (rowsOfChars % 2 === 0) ? rowsOfChars + 1 : rowsOfChars

        Repeater {
            model: asciiGrid.columns * asciiGrid.rows

            TerminalText {
                width: TerminalSettings.font_size
                height: TerminalSettings.font_size
                text: (asciiGrid.rows === 1) ? '0' : getRandomCharFromSet()
                font.bold: true
                color: '#ff6600'  // orange
            }
        }
    }

    function getRandomCharFromSet() {
        var index = getRandomInt(0, charSet.length - 1);
        return charSet[index];
    }

    /**
     * Returns a random integer between min (inclusive) and max (inclusive)
     * Using Math.round() will give you a non-uniform distribution!
     */
    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
}
