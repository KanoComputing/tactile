/**
 * app.h
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Main app.
 */


#ifndef __TACTILE_APP_H__
#define __TACTILE_APP_H__


#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <kano/kano_logging/kano_logging.h>

#include "display_screen.h"
#include "hw.h"
#include "progress.h"
#include "touch.h"


class App : public QGuiApplication
{
    Q_OBJECT

    public:
        App(int &argc, char **argv);

    protected:
        QQmlApplicationEngine engine;
        DisplayScreen display;
        HW hw;
        Progress progress;
        Touch touch;
        Logger logger;

        void clear_cursor_stack();

    protected slots:
        void show_cursor();
        void hide_cursor();
};

#endif  // _TACTILE_APP_H__
