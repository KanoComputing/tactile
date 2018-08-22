/**
 * display_screen.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Display properties.
 */


#include <QProcess>
#include "display_screen.h"


/**
 * Is the currently connected display a monitor?
 * This function returns false if overscan is needed for this display.
 */
bool DisplayScreen::is_monitor()
{
    QProcess proc;

    // FIXME: Ideally we would have a native version of this function rather than Python
    proc.start("python -c \"import sys; from kano.utils import is_monitor; sys.exit(is_monitor())\"");

    proc.waitForFinished(1000);
    return proc.exitCode() != 0;
}

/**
 * Returns whether the current display plugged in is
 * recognised as a Screen Kit.
 */
bool DisplayScreen::is_screen_kit() {
    QProcess proc;

    // FIXME: Ideally we would have a native version of this function rather than Python
    proc.start("python -c \"import sys; from kano_settings.system.display import is_screen_kit; sys.exit(is_screen_kit())\"");

    proc.waitForFinished(1000);
    return proc.exitCode() != 0;
}
