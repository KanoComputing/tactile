/**
 * display_screen.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Display properties.
 */


#include <QProcess>
#include <QDebug>

#include "display_screen.h"

/*
 * Is the currently connected display a monitor?
 * Placeholder to test this function on macOS.
 */
bool DisplayScreen::is_monitor()
{
    QProcess proc;

    // FIXME: Ideally we would have a native version of this function rather than Python
    proc.start("python -c \"import sys; sys.exit(0)\"");

    proc.waitForFinished(1000);
    return proc.exitCode() != 0;
}


/**
 * is_screen_kit()
 *
 * Returns whether the current display plugged in is
 * recognised as a Screen Kit.
 */
bool DisplayScreen::is_screen_kit() {
    QProcess proc;

    // FIXME: Ideally we would have a native version of this function rather than Python
    proc.start("python -c \"import sys; sys.exit(1)\"");

    proc.waitForFinished(1000);
    return proc.exitCode() != 0;
}
