/**
 * terminal_font.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Font to use in the terminal.
 */


import QtQuick 2.0
import QtQuick.Controls 1.4

import Tactile.Terminal 1.0


/**
 * For supported RichText formatting read:
 *     http://doc.qt.io/qt-5/richtext-html-subset.html
 */
Text {
    font.family: TerminalSettings.font_family
    font.pixelSize: TerminalSettings.font_size
    font.weight: TerminalSettings.font_weight
    color: TerminalSettings.fg_color
    textFormat: Text.StyledText
}
