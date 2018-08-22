/**
 * terminal_prompt.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Single line terminal prompt component.
 */


import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2

import Tactile.Terminal 1.0


RowLayout {
    signal response(string msg)

    property string prefix: ''
    property string prompt_marker: TerminalSettings.prompt_marker
    property alias text: prompt_box.text
    property var completion: []

    function forceActiveFocus() {
        prompt_box.forceActiveFocus()
    }

    id: prompt_line
    spacing: 15
    implicitHeight: prompt_box.height

    resources: [
        Component{
            id: cursor_blink
            Rectangle {
                id: cursor_rect
                width: TerminalSettings.font_size / 2
                height: TerminalSettings.font_size
                color: TerminalSettings.fg_color
                visible: parent.cursorVisible;

                PropertyAnimation on opacity  {
                    easing.type: Easing.OutSine
                    loops: Animation.Infinite
                    from: 0
                    to: 1.0
                    duration: 750
                }
            }
        }
    ]

    TerminalFont {
        text: prompt_marker + prefix
    }

    TextInput {
        id: prompt_box
        cursorPosition: 10
        cursorVisible: true
        cursorDelegate: cursor_blink
        font.family: TerminalSettings.font_family
        font.pixelSize: TerminalSettings.font_size
        font.weight: TerminalSettings.font_weight
        color: TerminalSettings.fg_color
        height: font.pixelSize
        Layout.fillWidth: true
        focus: true
        onAccepted: {
            focus = false;
            cursorVisible = false;
            prompt_line.response(text);
        }
        Keys.onTabPressed: autocomplete(text)

        function autocomplete(msg) {
            var len = completion.length,
                candidates = [],
                candidate,
                first_candidate,
                last_candidate,
                i;

            if (msg.length === 0 || completion === undefined) {
                return;
            }

            for (i = 0; i < len; i++) {
                candidate = completion[i]

                if (candidate.indexOf(msg) === 0) {
                    candidates.push(candidate);
                }
            }

            if (candidates.length === 0) {
                return;
            }

            candidates = candidates.sort();

            first_candidate = candidates[0];
            last_candidate = candidates[candidates.length - 1];
            len = first_candidate.length;
            i = 0;

            while (i < len && first_candidate.charAt(i) === last_candidate.charAt(i)) {
                i++
            }

            prompt_line.text = first_candidate.substring(0, i);
        }

        Component.onCompleted: {
            prompt_box.forceActiveFocus()
        }
    }
}
