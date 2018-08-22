/**
 * progress_base.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Allows the progress through the flow to be logged so the user can
 * continue where they finished off should they unplug before the end
 *
 * Supplements the platform-specific c++ file.
 */


#include <QFile>
#include <QJsonDocument>

#ifndef QT_NO_DEBUG
#    include <QDebug>
#endif  // QT_NO_DEBUG

#include "progress.h"


const QString Progress::CHECKPOINT_KEY = "checkpoint_id";


Progress::Progress(QObject *parent) :
    QObject(parent),
    progress(this->read_data())
{
    if (!Progress::STATE_DIR.exists()) {
        Progress::STATE_DIR.mkpath(".");
    }
}


Q_INVOKABLE void Progress::mark_checkpoint(const QString checkpoint_id)
{
    #ifndef QT_NO_DEBUG
        qDebug() << "Marking checkpoint:" << checkpoint_id;
    #endif  // QT_NO_DEBUG

    this->progress.insert(Progress::CHECKPOINT_KEY, checkpoint_id);
    this->save_data(this->progress);
}


Q_INVOKABLE void Progress::clear_checkpoint()
{
    QFile(Progress::STATE_FILE.filePath()).remove();
}


Q_INVOKABLE QJsonObject Progress::get_checkpoint()
{
    return this->progress;
}


Q_INVOKABLE void Progress::save_progress_data(const QJsonObject &data)
{
    #ifndef QT_NO_DEBUG
        qDebug() << "Saving progress data:" << data;
    #endif  // QT_NO_DEBUG

    for (auto it = data.constBegin(); it != data.constEnd(); ++it) {
        this->progress.insert(it.key(), it.value());
    }

    this->save_data(this->progress);
}


void Progress::save_data(const QJsonObject &data) const
{
    QFile state_file(Progress::STATE_FILE.filePath());

    if (!state_file.open(QIODevice::WriteOnly)) {
        #ifndef QT_NO_DEBUG
            qDebug() << "Failed to open Progress file"
                     << Progress::STATE_FILE.filePath()
                     << "for writing";
        #endif  // QT_NO_DEBUG

        return;
    }

    QJsonDocument data_doc(data);
    state_file.write(data_doc.toBinaryData());
    state_file.close();
}


QJsonObject Progress::read_data() const
{
    if (!Progress::STATE_FILE.exists()) {
        return QJsonObject();
    }

    QFile state_file(Progress::STATE_FILE.filePath());

    if (!state_file.open(QIODevice::ReadOnly)) {
#ifndef NO_QT_DEBUG
        qDebug() << "Failed to open Progress file"
                 << Progress::STATE_FILE.filePath()
                 << "for reading";
#endif  // NO_QT_DEBUG

        return QJsonObject();
    }

    QByteArray raw_data = state_file.readAll();
    state_file.close();

    QJsonDocument data = QJsonDocument::fromBinaryData(raw_data);

    return data.object();
}
