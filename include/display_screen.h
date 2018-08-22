/**
 * display_screen.h
 *
 * Copyright (C) 2017 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Display properties.
 */


#ifndef __TACTILE_DISPLAY_H__
#define __TACTILE_DISPLAY_H__


#include <QObject>
#include <QString>


class DisplayScreen : public QObject
{
    Q_OBJECT

    public:
        DisplayScreen(QObject *parent = 0) : QObject(parent) {};

        Q_INVOKABLE bool is_monitor();
        Q_INVOKABLE bool is_screen_kit();
};


#endif  // __TACTILE_DISPLAY_H__
