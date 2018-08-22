/**
 * sleep.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Component to perform a sleep using a timer.
 */


import QtQuick 2.0


Timer {
    signal wait_over()

    function sleep(msecs) {
        timer.interval = msecs;
        timer.start()
    }

    id: timer
    onTriggered: wait_over();
}
