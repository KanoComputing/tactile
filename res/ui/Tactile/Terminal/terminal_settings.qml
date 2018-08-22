/**
 * terminal_settings.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Settings for the terminal widget.
 */


pragma Singleton
import QtQuick 2.0

import "../colour_palette.js" as ColourPalette


QtObject {
    property color bg_color: 'black'
    property string bg_source: ''
    property color fg_color: 'white'
    property var font_family: 'FreeMono'
    property var font_weight: Font.Bold
    property string prompt_marker:
        '<b><font color="%1">user@kano</font><font color="%2"> ~ $</font></b>'
            .arg(ColourPalette.Colours.yellow)
            .arg(ColourPalette.Colours.blue);
    property int font_size: 24
    property int margins: 100
}
