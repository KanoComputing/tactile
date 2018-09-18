/**
 * tracker.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Wrappers for the tracking functions
 *
 * Platform specific tracking functions. Supplemented by the general C++ file.
 *
 */


#include <QProcess>

#include "tracker.h"
#include "../common/tracker_base.cpp"


void Tracker::run_tracker_command(QStringList args) const
{
    QProcess proc;
    proc.start("kano-tracker-ctl", args);

    proc.waitForFinished();
}
