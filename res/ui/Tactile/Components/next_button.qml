/**
 * next_button.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Styled button
 *
 */


import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Button {
    id: button

    height: 50

    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 150
            implicitHeight: 50
            color: control.pressed ? "#88C440" : "#9EE044"
            radius: 25
        }

        label: Text {
            font.family: "Bariol"
            font.pointSize: 18
            font.weight: Font.Bold
            color: "white"
            text: button.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
