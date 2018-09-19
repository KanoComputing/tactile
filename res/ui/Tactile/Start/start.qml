/**
 * start.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Title screen for app
 *
 */


import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import Tactile.Components 1.0

Item {
    signal done()

    property string text
    property string next_button_text
    property string note_text

    id: scene

    Rectangle {
        anchors.fill: parent
        color: '#414a50'
        z: -1
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: childrenRect.height

        InstructionText {
            id: title
            text: scene.text
            font.pointSize: 36
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        NextButton {
            onClicked: scene.done()
            anchors.top: title.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            text: scene.next_button_text
        }
    }

    InstructionText {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 100
        font.pointSize: 20
        text: scene.note_text
    }

}
