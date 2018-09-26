/**
 * X11Input.cpp
 *
 * Copyright (C) 2017 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
 *
 * Wrapper class to deal with hiding and disabling the X11 cursor
 */


#include <QProcess>
#include <QDebug>

#include "X11Input.h"


void X11Input::initialise() {
    m_inputProcess.setProgram("kano-dashboard-cursor");
    m_inputProcess.setProcessChannelMode(QProcess::ForwardedChannels);
}

void X11Input::capture() {
    #ifdef __arm__
        // Hide and disable the X11 cursor throughout our running lifetime
        if (!isRunning()) {
            m_inputProcess.start();
        } else {
            #ifdef QT_DEBUG
                qDebug() << "X11Input: capture: Process is already running!";
            #endif
        }
    #elif defined QT_DEBUG
        qDebug() << "X11Input: capture: Nothing to do on this platform!";
    #endif
}

void X11Input::restore() {
    #ifdef __arm__
        if (isRunning()) {
            #ifdef QT_DEBUG
                qDebug() << "X11Input: restore: Terminating process..";
            #endif
            m_inputProcess.kill();
            m_inputProcess.waitForFinished(300);  // ms
        }
    #elif defined QT_DEBUG
        qDebug() << "X11Input: restore: Nothing to do on this platform!";
    #endif
}

bool X11Input::isRunning() {
    bool isRunning = !(m_inputProcess.state() == QProcess::NotRunning);
    #ifdef QT_DEBUG
        qDebug() << "X11Input: isRunning:" << isRunning;
    #endif
    return isRunning;
}

void X11Input::clean() {
    if (m_inputProcess.state() == QProcess::Running) {
        #ifdef QT_DEBUG
            qDebug() << "X11Input: clean: Terminating process..";
        #endif
        m_inputProcess.kill();
    }
}
