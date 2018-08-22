/**
 * hw.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Hardware configuration settings.
 */


#include "hw.h"


Q_INVOKABLE bool HW::is_ck2_pro()
{
    return false;
}


Q_INVOKABLE bool HW::is_ck2_lite()
{
    return false;
}


Q_INVOKABLE bool HW::is_ckt()
{
    return true;
}
