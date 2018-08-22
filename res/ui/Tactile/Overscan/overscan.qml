/**
 * overscan.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Allows the overscan settings to be set.
 */


import QtQuick 2.3

import Tactile.Terminal 1.0


Item {
    signal overscan_set()

    property url src: 'corner.png'
    property int img_width: 50
    property int img_height: img_width
    property int timeout: 120  // seconds

    property int overscan_inc: 3

    function increase_overscan() {
        parent.overscan_value = Math.min(
            parent.overscan_value + overscan_inc,
            52
        );
    }

    function decrease_overscan() {
        parent.overscan_value = Math.max(
            parent.overscan_value - overscan_inc,
            0
        );
    }

    id: scene

    anchors.fill: parent

    focus: true
    Component.onCompleted: {
        forceActiveFocus()
    }

    Keys.onUpPressed: decrease_overscan();
    Keys.onRightPressed: decrease_overscan();
    Keys.onDownPressed: increase_overscan();
    Keys.onLeftPressed: increase_overscan();
    Keys.onReturnPressed: {
        if (!next_text.visible) {
            return;
        }

        launcher.start_app(
            "sudo kano-settings-cli set overscan %1 %1 %1 %1"
            .arg(parent.overscan_value),
            "",
            true
        );

        overscan_set();
    }

    Image {
        source: src
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.left: parent.left
        width: img_width
        height: img_height
    }

    Image {
        source: src
        fillMode: Image.PreserveAspectFit
        anchors.top: parent.top
        anchors.right: parent.right
        width: img_width
        height: img_height
        transformOrigin: Item.Center
        rotation: 90
    }

    Image {
        source: src
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: img_width
        height: img_height
        transformOrigin: Item.Center
        rotation: 270
    }

    Image {
        source: src
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: img_width
        height: img_height
        transformOrigin: Item.Center
        rotation: 180
    }

    Item {
        id: instructions
        anchors.centerIn: parent
        implicitHeight: explain_img.height + explain_txt.height + explain_txt.anchors.margins
        implicitWidth: explain_img.width * 1.5

        Image {
            id: explain_img
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: 'overscan-borders.png'
            fillMode: Image.PreserveAspectFit
            height: 200
        }

        TerminalText {
            id: explain_txt
            anchors.top: explain_img.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 30
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap

            text: qsTr(
                "Use the ▲ ▼ keys <br><br>Push the markers to the screen's edge...<br>...but make sure they don't disappear!"
            )
        }
    }

    TerminalText {
        id: next_text
        visible: scene.parent.overscan_value < 50
        text: qsTr(
            "When you're happy, press Enter"
        )

        anchors.top: instructions.bottom
        anchors.left: instructions.left
        anchors.right: instructions.right
        anchors.margins: 30
    }

    Timer {
        interval: timeout * 1000  // Milliseconds
        running: timeout > 0
        onTriggered: overscan_set()
    }
}
