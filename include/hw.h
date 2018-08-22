/**
 * hw.h
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Hardware configuration settings.
 */


#ifndef __TACTILE_HW_H__
#define __TACTILE_HW_H__


#include <QObject>
#include <QString>


const QString DETECTION_BUS = "me.kano.boards";
const QString DETECTION_METHOD = "is_plugged";

const QString KANO_BOARDS_SERVICE_API_IFACE = "me.kano.boards.API";
const QString CK2_LITE_PATH = "/me/kano/boards/PiHat";
const QString CK2_PRO_PATH = "/me/kano/boards/CK2ProHat";


class HW : public QObject
{
    Q_OBJECT

    public:
        HW(QObject *parent = 0) : QObject(parent) {};

        Q_INVOKABLE bool is_ck2_pro();
        Q_INVOKABLE bool is_ck2_lite();
        Q_INVOKABLE bool is_ckt();
};


#endif  // __TACTILE_HW_H__
