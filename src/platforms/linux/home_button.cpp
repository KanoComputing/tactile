/**
 * home_button.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Controls for the home button
 */


#include <QProcess>

#include "home_button.h"


void HomeButton::hide_home_button()
{
    QProcess proc;
    proc.start("kano-home-button-visible no");
    proc.waitForFinished();
}


void HomeButton::show_home_button()
{
    QProcess proc;
    proc.start("kano-home-button-visible yes");
    proc.waitForFinished();
}
