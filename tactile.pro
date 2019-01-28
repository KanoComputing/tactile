# tactile.pro
#
# Copyright (C) 2018 Kano Computing Ltd.
# License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
#
# Main project file for qmake.


TEMPLATE = app

CONFIG += \
    kano_build_options \
    # kano_qt_sdk

QT += \
    qml \
    quick
CONFIG += \
    c++11 \
    debug \
    kano_debug_target

unix:!macx {
    # QT += dbus
}

include(build/i18n.pri)
include(build/headers.pri)
include(build/sources.pri)

RESOURCES += res/all.qrc

QML_IMPORT_PATHS = \
    $$PWD/res/ui \
    $$SYSTEM_QML_PATHS \
    "/usr/share/tactile/ui"

DEFINES += QML_IMPORT_PATHS=\\\"$$join($$list($$QML_IMPORT_PATHS), ':')\\\"

DESTDIR = bin
OBJECTS_DIR = build/obj
MOC_DIR = build/moc
RCC_DIR = build/rcc
UI_DIR = build/ui

# TODO: Move the logic below into kano-qt-sdk and remove!

# Move the generated i18n folder into the res/ dir
QMAKE_POST_LINK += \
    rm -rf $$PWD/res/i18n && \
    mv $$PWD/i18n $$PWD/res

# Compile out debugging statements for release.
# Comment this out during development.
DEFINES += QT_NO_DEBUG
