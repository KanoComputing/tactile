/**
 * main.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Entry point for application.
 */


#include "app.h"


int main(int argc, char *argv[])
{
    App app(argc, argv);
    return app.exec();
}
