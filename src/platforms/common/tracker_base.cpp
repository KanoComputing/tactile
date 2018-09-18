/**
 * tracker_base.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Wrappers for the tracking functions
 *
 * Supplemented by the platform-specific C++ file.
 *
 */


#include <QStringList>

#include "tracker.h"


const QString Tracker::TRACKER_CMD = "kano-tracker-ctl";


Tracker::Tracker(QCoreApplication *parent) :
    QObject(parent),
    app_name("tactile"),
    pid(parent ? QString::number(parent->applicationPid()) : "0")
{
}


Q_INVOKABLE void Tracker::start_session() const
{
    QStringList args;
    args << "session" << "start" << this->app_name << this->pid;

    this->run_tracker_command(args);
}


Q_INVOKABLE void Tracker::end_session() const
{
    QStringList args;
    args << "session" << "end" << this->app_name << this->pid;

    this->run_tracker_command(args);
}


Q_INVOKABLE void Tracker::track_action(QString name) const
{
    QStringList args;
    args << "session" << "action" << name;

    this->run_tracker_command(args);
}


Q_INVOKABLE void Tracker::track_data(QString event_name, QString data) const
{
    QStringList args;
    args << "session" << "data" << event_name << data;

    this->run_tracker_command(args);
}
