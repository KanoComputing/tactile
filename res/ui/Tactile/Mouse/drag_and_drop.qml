/**
 * drag_and_drop.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * A scene to practice drag and drop.
 */


import QtQuick 2.0
import QtGraphicalEffects 1.0
import Multimedia 5.8

import Tactile.Mouse 1.0
import Tactile.Terminal 1.0


TerminalHeader {
    signal blocks_connected()
    signal finished_playing()
    signal wait_over()

    property string input_block: ''
    property string dragged_block: ''
    property string connected_blocks: ''
    property string click_help: ''
    property url click_help_img: ''
    property string drag_help: ''
    property url drag_help_img: ''
    property color drag_arrow_color: '#000000'
    property int timeout: 30  // seconds

    property real bounce_param: 0
    property int bounce_margin: 10 + 5 * (1 + Math.sin(bounce_param))
    NumberAnimation on bounce_param {
        loops: Animation.Infinite
        from: 0
        to: 2 * Math.PI
        duration: 1250
    }

    property bool _blocks_connected: false

    function set_horizontal_layout() {
        state = 'horizontal'
    }
    function set_vertical_layout() {
        state = 'vertical'
    }

    function configure_blocks(conf) {
        // TODO: Migrate these settings into something more manageable
        input_block = conf['input_block'] || input_block;
        dragged_block = conf['dragged_block'] || dragged_block;
        connected_blocks = conf['connected_blocks'] || connected_blocks;
        click_help = conf['click_help'] ||  click_help;
        click_help_img = conf['click_help_img'] || click_help_img;
        drag_help = conf['drag_help'] || drag_help;
        drag_help_img = conf['drag_help_img'] || drag_help_img;
        drag_arrow_color = conf['drag_arrow_color'] || drag_arrow_color;

        if (conf['layout'] === 'vertical') {
            set_vertical_layout();
        } else {
            set_horizontal_layout();
        }

    }

    states: [
        State {
            name: 'horizontal'
            PropertyChanges {
                target: drop_area
                width: 80
                x: target_img.width - drop_area.width / 2
                anchors.top: target_img.top
                anchors.bottom: target_img.bottom
            }
            PropertyChanges {
                target: draggable_block
                x: target_img.x + move_hint.width + 2 * move_hint.anchors.margins + target_img.width
                y: target_img.y
                Drag.hotSpot.x: 0
                Drag.hotSpot.y: draggable_block.height / 2
            }
            PropertyChanges {
                target: move_hint
                width: 100
                anchors.verticalCenter: target_img.verticalCenter
                anchors.left: target_img.right
            }
            PropertyChanges {
                target: arrow
                anchors.verticalCenter: move_hint.verticalCenter
                anchors.left: move_hint.left
                anchors.right: move_hint.right
                rotation: 0
            }
        },
        State {
            name: 'vertical'
            PropertyChanges {
                target: drop_area
                height: 40
                y: target_img.height - drop_area.height / 2
                anchors.left: target_img.left
                anchors.right: target_img.right
            }
            PropertyChanges {
                target: draggable_block
                x: target_img.x
                y: target_img.y + move_hint.height + 2 * move_hint.anchors.margins  + target_img.height
                Drag.hotSpot.x: draggable_block.width / 2
                Drag.hotSpot.y: 0
            }
            PropertyChanges {
                target: move_hint
                height: 100
                anchors.top: target_img.bottom
                anchors.left: target_img.left
            }
            PropertyChanges {
                target: arrow
                anchors.horizontalCenter: move_hint.horizontalCenter
                anchors.top: move_hint.top
                anchors.bottom: move_hint.bottom
                rotation: 90
            }
        }
    ]

    id: drag_and_drop

    content_height: draggable_block.visible ?
        draggable_block.y + draggable_block.height :
        target_img.y + target_img.height

    Image {
        id: target_img
        x: 75
        y: 0
        source: input_block
        layer.enabled: drop_area.containsDrag
        layer.effect: Glow {
            samples: 17
            radius: 8
            spread: 0.5
            color: "white"
            transparentBorder: true
        }

        DropArea {
            id: drop_area
        }

    }

    Connections {
        target: audio
        onFinished_playing: drag_and_drop.finished_playing()
    }


    Item {
        id: move_hint
        visible: draggable_block.Drag.active && !drop_area.containsDrag
        anchors.margins: 40

        Image {
            id: arrow
            source: 'arrow.png'
            fillMode: Image.PreserveAspectFit
        }

        Loader {
            anchors.top: arrow.bottom
            anchors.horizontalCenter: arrow.horizontalCenter
            anchors.margins: sourceComponent ? bounce_margin : 0

            Component {
                id: move_tooltip
                Tooltip {
                    text: drag_help
                    img: drag_help_img
                }
            }

            sourceComponent: drag_help ? move_tooltip : undefined
        }
    }

    Image {
        id: draggable_block
        source: dragged_block

        Drag.active: drag_area.drag.active || drag_area.containsPress

        MouseArea {
            id: drag_area
            anchors.fill: parent
            cursorShape: drag_area.drag.active || drag_area.containsPress ?
                Qt.ClosedHandCursor : Qt.OpenHandCursor
            hoverEnabled: true

            onPressed: parent.grabToImage(function(result) {
                parent.Drag.imageSource = result.url;
            })
            drag.target: parent
            drag.minimumX: 0
            drag.maximumX: 0.6 * drag_and_drop.width
            drag.minimumY: -height / 2
            drag.maximumY: 0.5 * drag_and_drop.height

            onReleased: {
                if (drop_area.containsDrag) {
                    target_img.source = connected_blocks;
                    draggable_block.visible = false;
                    drag_and_drop.blocks_connected();
                    _blocks_connected = true;
                    connect_sound.play();
                }
            }
        }
    }

    Loader {
        anchors.top: draggable_block.bottom
        anchors.horizontalCenter: draggable_block.horizontalCenter
        anchors.margins: sourceComponent ? bounce_margin : 0

        Component {
            id: drag_tooltip
            Tooltip {
                text: click_help
                img: click_help_img
                visible: !draggable_block.Drag.active && !_blocks_connected

            }
        }
        sourceComponent: click_help ? drag_tooltip : undefined
    }

    Audio {
        id: connect_sound
        source: 'click.wav'
    }

    Timer {
        interval: timeout * 1000  // Milliseconds
        running: timeout > 0
        onTriggered: blocks_connected()
    }
}
