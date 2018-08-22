/**
 * touch.h
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Functions to support touch devices.
 */


#ifndef __TACTILE_TOUCH_H__
#define __TACTILE_TOUCH_H__


#include <QObject>


class Touch : public QObject
{
    Q_OBJECT

    public:
        Touch(QObject *parent = nullptr) : QObject(parent) {};

        Q_INVOKABLE bool is_touch_supported(const QString username = "");
};


#endif  // __TACTILE_TOUCH_H__
