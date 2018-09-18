/**
 * tracker.h
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Wrappers for the tracking functions
 *
 */


#ifndef __TACTILE_TRACKER_H__
#define __TACTILE_TRACKER_H__


#include <QCoreApplication>
#include <QObject>
#include <QString>
#include <QStringList>


class Tracker : public QObject
{
    Q_OBJECT

    public:
        Tracker(QCoreApplication *parent = nullptr);

        void run_tracker_command(QStringList args) const;
        Q_INVOKABLE void start_session() const;
        Q_INVOKABLE void end_session() const;
        Q_INVOKABLE void track_action(QString name) const;
        Q_INVOKABLE void track_data(QString event_name, QString data) const;

        static const QString TRACKER_CMD;
    protected:
        QString app_name;
        QString pid;
};


#endif  // __TACTILE_TRACKER_H__
