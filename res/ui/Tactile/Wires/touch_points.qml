/**
 * touch_points.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Scene which explains touch coordinates
 *
 */


import QtQuick 2.0
import QtQuick.Particles 2.0

import Tactile.Components 1.0
import Tactile.Pixels 1.0
import Tactile.Wires 1.0


Rectangle {
    signal done()
    signal pressed()
    signal correct_response()

    function prompt(text) {
        instructions_text.text = text || '';
    }

    function quiz(params) {
        params = params || {};

        quiz_box.visible = true;
        quiz_box.question = params.question || '';
        quiz_box.responses = params.responses || [];
        quiz_box.answer = params.answer || '';
    }

    id: scene

    color: "black"
    property bool touched: false

    MultiPointTouchArea {
        id: toucharea
        onPressed: {
            touched = true;
            scene.pressed();
        }
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 5
        touchPoints: [
            TouchPoint { id: touch1 },
            TouchPoint { id: touch2 },
            TouchPoint { id: touch3 },
            TouchPoint { id: touch4 },
            TouchPoint { id: touch5 }
        ]
    }

    TouchIndicator {
        visible: touched ? touch1.pressed : true
        pos_x: touched ? touch1.x : 800
        pos_y: touched ? touch1.y : 500
        color: 'red'
    }

    TouchIndicator {
        visible: touch2.pressed
        pos_x: touch2.x
        pos_y: touch2.y
        color: 'orange'
    }

    TouchIndicator {
        visible: touch3.pressed
        pos_x: touch3.x
        pos_y: touch3.y
        color: 'orange'
    }

    InstructionText {
        id: instructions_text
        width: parent.width / 2
        wrapMode: Text.WordWrap
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30
    }

    Rectangle {
        id: quiz_box

        property string question: ''
        property var responses: []
        property int answer

        visible: false
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 30

        PixelExplosion {
            id: exploder
            anchors.fill: parent
            onExploded: scene.correct_response()
        }

        InstructionText {
            id: quiz_question
            text: quiz_box.question
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Column {
            anchors.top: quiz_question.bottom
            anchors.left: parent.left
            anchors.topMargin: 30

            Repeater {
                id: quiz_answers
                model: quiz_box.responses.length

                Item {
                    property bool is_answer: index === quiz_box.answer
                    property int answer_idx: index

                    id: response_box
                    height: response_text.contentHeight + response_text.anchors.margins * 2
                    width: response_text.contentWidth + response_text.anchors.margins * 2

                    InstructionText {
                        id: response_text
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: 10
                        text: String.fromCharCode(65 + response_box.answer_idx) + ')  '
                            + quiz_box.responses[response_box.answer_idx]

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (!is_answer) {
                                    validation_animation.running = true;
                                    return;
                                }

                                var coords = response_text.mapToItem(
                                    exploder,
                                    response_text.width / 2,
                                    response_text.height / 2
                                );
                                exploder.explode(30, coords.x, coords.y);
                            }
                        }
                    }

                    Rectangle {
                        color: is_answer ? 'green' : 'red'
                        opacity: 0
                        radius: height / 2
                        anchors.fill: parent

                        SequentialAnimation on opacity {
                            id: validation_animation
                            running: false

                            NumberAnimation {
                                from: 0
                                to: 1
                            }
                            NumberAnimation {
                                from: 1
                                to: 0
                            }
                            ScriptAction {
                                script: is_answer ? scene.correct_response() : null
                            }
                        }
                    }
                }
            }
        }
    }
}
