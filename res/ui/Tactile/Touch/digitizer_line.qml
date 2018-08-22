/**
 * digitizer_line.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * A single line for a touch screen animation.
 */


import QtQuick 2.7


Item {
    id: root

    property int touchX: 0
    property int touchY: 0
    property int maxLength: 0
    property color color: '#FFFFFF'
    property int lineWidth: 2

    property int _length: 0

    function touch() {
        animation.grow();
    }

    function draw(ctx) {
        ctx.strokeStyle = color;
        ctx.lineWidth = lineWidth;
        ctx.beginPath();
        ctx.moveTo(touchX - _length, touchY);
        ctx.lineTo(touchX + _length, touchY);
        ctx.moveTo(touchX, touchY - _length);
        ctx.lineTo(touchX, touchY + _length);
        ctx.stroke();
    }

    NumberAnimation on _length {
        id: animation

        from: 0
        to: root.maxLength
        duration: 1100  // ms
        easing.type: Easing.OutQuad

        property bool _growing: true

        onStopped: {
            shrink();
        }

        function grow() {
            if (_growing)
                return;

            _growing = true;
            from = 0;
            to = root.maxLength;
            restart();
        }

        function shrink() {
            if (!_growing)
                return;

            _growing = false;
            from = root.maxLength;
            to = 0;
            restart();
        }
    }
}
