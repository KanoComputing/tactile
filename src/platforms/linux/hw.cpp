/**
 * hw.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Hardware configuration settings.
 */


#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusReply>
#include <QProcess>

#include "hw.h"


bool detect_board(const QString path, const QString iface)
{
    QDBusInterface service(
        DETECTION_BUS,
        path,
        iface,
        QDBusConnection::systemBus()
    );
    QDBusReply<bool> reply = service.call(
        QDBus::BlockWithGui,
        DETECTION_METHOD
    );

    if (!reply.isValid())
        return false;

    return reply.value();
}


/**
 * Determine if the kit currently running is a CKC
 *
 * FIXME: All the logic for this is currently tied up in the Python
 *        `kano_peripherals.wrappers.detection.is_ck2_pro()` function. Ideally
 *         this would either be accessible via a library function of accessed
 *         directly via a DBus interface on the boards daemon but for now just
 *         do the simplest Python call.
 */
Q_INVOKABLE bool HW::is_ck2_pro()
{
    QProcess proc;

    // FIXME: Ideally we would have a native version of this function rather
    //        than Python
    proc.start(
        "python -c \""
            "import sys;"
            "from kano_peripherals.wrappers.detection import is_ck2_pro;"
            "sys.exit(is_ck2_pro())"
        "\""
    );

    proc.waitForFinished(3000); // NB, it actually takes over a second.
    return proc.exitCode() != 0;
}


Q_INVOKABLE bool HW::is_ck2_lite()
{
    return detect_board(
        CK2_LITE_PATH,
        KANO_BOARDS_SERVICE_API_IFACE
    );
}


/**
 * Determine if the kit currently running is a CKT
 *
 * FIXME: All the logic for this is currently tied up in the Python
 *        `kano_peripherals.wrappers.detection.is_ckt()` function. Ideally
 *         this would either be accessible via a library function of accessed
 *         directly via a DBus interface on the boards daemon but for now just
 *         do the simplest Python call.
 */
Q_INVOKABLE bool HW::is_ckt()
{
    QProcess proc;

    // FIXME: Ideally we would have a native version of this function rather
    //        than Python
    proc.start(
        "python -c \""
            "import sys;"
            "from kano_peripherals.wrappers.detection import is_ckt;"
            "sys.exit(is_ckt())"
        "\""
    );

    proc.waitForFinished(3000); // NB, it actually takes over a second.
    return proc.exitCode() != 0;
}
