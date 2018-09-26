/**
 * X11Input.h
 *
 * Copyright (C) 2017 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
 *
 * Wrapper class to deal with hiding and disabling the X11 cursor.
 * TODO: turn this into a Singleton rather than a static class.
 */


#ifndef __X11MOUSE_H__
#define __X11MOUSE_H__


#include <QProcess>

#include "Singleton.h"


class X11Input: public Singleton<X11Input>
{
    public:
        void initialise();
        void clean();

        void capture();
        void restore();
        bool isRunning();

    private:
        QProcess m_inputProcess;
};


#endif
