/**
 * text_next_scene.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene with text and a next button
 */

import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root

    signal next()

    anchors.fill: parent

    property string text
    property string next_button_text

    // @TODO figure out how to set background color
    // color: "#414a50"

    Text {
        text: parent.text
        font.family: "Bariol"
        font.pointSize: 36
        anchors.horizontalCenter: parent.horizontalCenter
        font.weight: Font.Bold
        color: "white"
        y: parent.height * 0.3
    }

    Button {
        id: next_button
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.4

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
                text: parent.next_button_text
                horizontalAlignment: Text.AlignHCenter
                y: 9
            }
        }
    }

    Component.onCompleted: {
        next_button.clicked.connect(next);
    }
}
