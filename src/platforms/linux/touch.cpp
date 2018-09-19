/**
 * touch.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Functions to support touch devices
 */


#include <QProcess>

#include "touch.h"


/**
 * Checks for touch support.
 *
 * Currently this ustilises the `touch-detect` binary provided by
 * `kano-touch-support`. Unfortunately, this also requires that there is an X
 * server running so we require the username to switch to that user.
 *
 * Ideally, this would use the platform-independent
 * `QTouchDevice::devices().count()` but unfortunately this does not work in
 * the current RPi configuration. In this scenario, we wouldn't need to pass
 * the username.
 */
Q_INVOKABLE bool Touch::is_touch_supported()
{
    QProcess proc;
    proc.start("touch-detect");
    proc.waitForFinished();

    return proc.exitCode() == 0;
}
