/**
 * touch_screen_digitizer.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Touch screen interactive animation.
 */


import QtQuick 2.9
import QtQuick.Particles 2.0


Item {
    id: root

    property int rows: 25
    property int columns: 40

    signal touched()

    // Private members.
    property int _rowSpacing: height / rows
    property int _columnSpacing: width / columns
    property var _digitizerLines
    property var _digitizerLineComponent


    ParticleSystem {
        id: particles
        anchors.fill: parent

        ImageParticle {
            source: 'particle.png'
            alpha: 0
            colorVariation: 0.6
            rotationVariation: 360
        }
    }

    // NB: The emitRate needs to be larger than the maximum number of particles
    // you expect to have on at a time to prevent the system from flickering.
    Emitter {
        id: emitter
        system: particles
        enabled: false
        emitRate: 1500
        size: 18
        sizeVariation: 4
        lifeSpan: 300
        lifeSpanVariation: 75
        velocity: AngleDirection {
            magnitude: 250;
            magnitudeVariation: 50;
            angleVariation: 360
        }
    }

    Canvas {
        id: canvas

        property alias updatedTouchPoints: touchArea.updatedTouchPoints

        signal touchUpdated(var touchPoints)
        signal draw(var ctx)

        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Cooperative
        anchors.fill: parent

        MultiPointTouchArea {
            id: touchArea
            anchors.fill: parent

            property list<TouchPoint> updatedTouchPoints

            onTouchUpdated: {
                updatedTouchPoints = touchPoints;
            }
        }

        Component.onCompleted: {
            touchArea.touchUpdated.connect(canvas.touchUpdated);
        }

        onPaint: {
            var ctx = getContext('2d');
            draw(ctx);
        }
    }

    Timer {
        id: loopTimer
        interval: 25  // ms
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            _touch(canvas.updatedTouchPoints);
            canvas.requestPaint();
        }
    }

    Component.onCompleted: {
        // Initialising and loading data.
        _digitizerLines = new Object();
        _loadDigitizerLineComponent();

        // Connecting to touch and draw events.
        canvas.draw.connect(_draw);

        // Start the animation routine.
        loopTimer.start();
    }

    // --- Private methods: Handling Controls / Draw --------------------------

    function _touch(touchPoints) {
        if (touchPoints.length == 0)
            return;

        var lineId, touchPoint, normalisedPoint

        for (var i = 0; i < touchPoints.length; i++) {
            touchPoint = touchPoints[i]
            normalisedPoint = _normaliseDigitizerPoint(touchPoint);
            lineId = _convertTouchPointToId(normalisedPoint);

            if (lineId in _digitizerLines) {
                _digitizerLines[lineId].touch();
            } else {
                _addNewDigitizerLine(lineId, normalisedPoint);
            }
            emitter.burst(5, touchPoint.x, touchPoint.y);
        }
        touched();
    }

    function _draw(ctx) {
        // Clear the drawing canvas.
        ctx.reset();

        for (var key in _digitizerLines) {
            _digitizerLines[key].draw(ctx);
        }
    }

    // --- Private methods: helpers -------------------------------------------

    function _normaliseDigitizerPoint(touchPoint) {
        var point = {x: 0, y: 0};
        point.x = Math.round(touchPoint.x / _columnSpacing) * _columnSpacing;
        point.y = Math.round(touchPoint.y / _rowSpacing) * _rowSpacing;
        return point;
    }

    function _convertTouchPointToId(touchPoint) {
        return "" + touchPoint.x + "-" + touchPoint.y
    }

    function _loadDigitizerLineComponent() {
        _digitizerLineComponent = Qt.createComponent('digitizer_line.qml');

        if (_digitizerLineComponent.status != Component.Ready) {
            console.log("[ERROR] _addNewDigitizerLine: Component not ready!");

            if (_digitizerLineComponent.status == Component.Error) {
                console.log("[ERROR] _addNewDigitizerLine: " +
                            _digitizerLineComponent.errorString());
            }
        }
    }

    function _addNewDigitizerLine(lineId, normalisedPoint) {
        var digitizerLine = _digitizerLineComponent.createObject(null, {
            'touchX': normalisedPoint.x,
            'touchY': normalisedPoint.y,
            'maxLength': width * 1.8,
        });
        if (digitizerLine == null) {
            console.log("_addNewDigitizerLine: Object is null!");
            return;
        }
        _digitizerLines[lineId] = digitizerLine;
    }
}
