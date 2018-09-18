/**
 * instruction_text.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Styled text
 *
 */


import QtQuick 2.0


Item {
    signal clicked()

    property alias instruction_text: prompt_text.text
    property alias button_text: next_btn.text
    property alias button_visible: next_btn.visible

    property bool bg_enabled: false

    function prompt(text, params) {
        params = params || {};

        instruction_text = text || '';
        button_text = params.button_text || '';
        bg_enabled = params.bg_enabled || false;
    }

    id: box

    states: [
        State {
            name: 'top-left'
            PropertyChanges {
                target: box
                anchors.top: box.parent.top
                anchors.left: box.parent.left
            }
        },
        State {
            name: 'bottom-right'
            PropertyChanges {
                target: box
                anchors.right: box.parent.right
                anchors.bottom: box.parent.bottom
            }
        },
        State {
            name: 'horizontal-center'
            PropertyChanges {
                target: box
                anchors.horizontalCenter: box.parent.horizontalCenter
            }
            PropertyChanges {
                target: prompt_text
                horizontalAlignment: Text.AlignHCenter
            }
            PropertyChanges {
                target: content_box
                width: 700
            }
            PropertyChanges {
                target: next_btn
                anchors.horizontalCenter: prompt_text.horizontalCenter
                anchors.left: undefined
            }
        }
    ]
    state: 'bottom-right'
    visible: instruction_text || button_text
    anchors.margins: 90
    z: 1

    height: content_box.height + content_box.anchors.margins * 2
    width: content_box.width + content_box.anchors.margins * 2

    Item {
        id: content_box

        width: 500
        height: next_btn.visible ?
            prompt_text.height + next_btn.height + 30 :
            prompt_text.height
        anchors.centerIn: parent
        anchors.margins: 30
        z: 1

        InstructionText {
            id: prompt_text
            color: bg_enabled ? 'black' : 'white'
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
        }

        NextButton {
            id: next_btn
            onClicked: box.clicked()
            visible: text
            anchors.top: prompt_text.bottom
            anchors.left: prompt_text.left
            anchors.topMargin: 30
        }
    }

    Rectangle {
        visible: parent.visible && bg_enabled
        anchors.fill: parent
        color: 'white'
        opacity: parent.visible ? 0.8 : 0
        radius: 10
    }
}
