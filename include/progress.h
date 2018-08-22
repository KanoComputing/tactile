/**
 * progress.h
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Allows the progress through the flow to be logged so the user can
 * continue where they finished off should they unplug before the end.
 */


#ifndef __TACTILE_PROGRESS_H__
#define __TACTILE_PROGRESS_H__


#include <QObject>
#include <QDir>
#include <QFileInfo>
#include <QString>
#include <QJsonObject>
#include <QDebug>


class Progress : public QObject
{
    Q_OBJECT

    public:
        Progress(QObject *parent = 0);

        static const QDir STATE_DIR;
        static const QString STATE_FILE_NAME;
        static const QFileInfo STATE_FILE;

        Q_INVOKABLE void mark_checkpoint(const QString checkpoint_id);
        Q_INVOKABLE void clear_checkpoint();
        Q_INVOKABLE QJsonObject get_checkpoint();
        Q_INVOKABLE void save_progress_data(const QJsonObject &data);

    protected:
        void save_data(const QJsonObject &data) const;
        QJsonObject read_data() const;

        QJsonObject progress;

        // Keys
        static const QString CHECKPOINT_KEY;
};


#endif  // __TACTILE_PROGRESS_H__
