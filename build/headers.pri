# headers.pri
#
# Copyright (C) 2018 Kano Computing Ltd.
# License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
#
# Complemements the main project file to specify include files.


INCLUDEPATH += $$PWD/../include
HEADER_FILES = \
    app.h \
    display_screen.h \
    home_button.h \
    hw.h \
    progress.h \
    Singleton.h \
    touch.h \
    tracker.h \
    X11Input.h

for (HEADER, HEADER_FILES) {
    HEADERS *= $$INCLUDEPATH/$$HEADER
}
