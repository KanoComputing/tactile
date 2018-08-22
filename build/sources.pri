# sources.pri
#
# Copyright (C) 2018 Kano Computing Ltd.
# License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
#
# Complemements the main project file to specify source files.


SRC_DIR = $$PWD/../src
SRC_FILES = \
    app.cpp \
    main.cpp

for (SRC, SRC_FILES) {
    SOURCES *= $$SRC_DIR/$$SRC
}


PLATFORM_BASE_DIR = $$SRC_DIR/platforms

macx {
    PLATFORM_DIR = $$PLATFORM_BASE_DIR/macosx
} else:unix {
    PLATFORM_DIR = $$PLATFORM_BASE_DIR/linux
}


PLATFORM_SRC_FILES = \
    display_screen.cpp \
    hw.cpp \
    progress.cpp \
    touch.cpp

for (SRC, PLATFORM_SRC_FILES) {
    SOURCES *= $$PLATFORM_DIR/$$SRC
}
