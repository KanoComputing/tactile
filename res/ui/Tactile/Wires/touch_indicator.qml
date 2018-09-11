/**
 * touch_indicator.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Marker with label for a touch event
 *
 */


import QtQuick 2.0


Item {
    property alias color: indicator.color
    property int size: 100
    property alias text: label.text

    property int pos_x
    property int pos_y

    x: pos_x - (indicator.x + indicator.width / 2)
    y: pos_y - (indicator.y + indicator.height / 2)

    Rectangle {
        id: label_box
        color: 'white'

        property int margins: 20

        anchors.bottom: indicator.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10

        implicitWidth: childrenRect.width + 2 * margins
        implicitHeight: childrenRect.height + 2 * margins
        radius: 10

        Text {
            id: label
            text: "Touch started!\n" +
                "X = " + Math.round(pos_x) +"\n" +
                "Y = " + Math.round(pos_y)
            font.family: "Bariol"
            font.weight: Font.Bold
            font.pointSize: 20
            lineHeight: 1.1
            color: 'black'
            //anchors.centerIn: parent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: label_box.margins
        }
    }

    Rectangle {
        id: indicator
        width: size
        height: size
        radius: width / 2
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
