/**
 * touch.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Functions to support touch devices
 *
 */


#include "touch.h"


Q_INVOKABLE bool Touch::is_touch_supported(const QString username)
{
    return true;
}
