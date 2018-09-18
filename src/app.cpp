/**
 * app.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Main app.
 */


#include <QtQml>
#include <QDir>
#include <QString>
#include <QStringList>
#include <QCursor>
#include <QDebug>

#include "app.h"


App::App(int &argc, char **argv) :
    QGuiApplication(argc, argv),
    logger("qml"),
    tracker(this)
{
    QStringList include_paths =
#ifdef QML_IMPORT_PATHS
        QString(QML_IMPORT_PATHS).split(':');
#else
    {
        QDir(QCoreApplication::applicationDirPath())
            .absoluteFilePath("../../../../res/ui"),
        QDir(QCoreApplication::applicationDirPath())
            .absoluteFilePath("../res/ui"),
    };
#endif  // QML_IMPORT_PATH

    for (auto path : include_paths) {
#ifdef DEBUG
        qDebug() << "Adding import path:" << path;
#endif  // DEBUG
        this->engine.addImportPath(path);
    }

    auto *ctx = this->engine.rootContext();
    ctx->setContextProperty("app", this);
    ctx->setContextProperty("display", &this->display);
    ctx->setContextProperty("hw", &this->hw);
    ctx->setContextProperty("logger", &this->logger);
    ctx->setContextProperty("progress", &this->progress);
    ctx->setContextProperty("touch", &this->touch);
    ctx->setContextProperty("tracker", &this->tracker);

    Logger::set_app_name("tactile");
    Logger::install_syslog();

    this->tracker.start_session();
    this->engine.load(QUrl(QStringLiteral("qrc:/ui/main.qml")));
}


App::~App()
{
    this->tracker.end_session();
}


void App::clear_cursor_stack()
{
    while (this->overrideCursor() != nullptr) {
        this->restoreOverrideCursor();
    }
}


void App::show_cursor()
{
    this->clear_cursor_stack();
}


void App::hide_cursor()
{
    this->clear_cursor_stack();
    this->setOverrideCursor(QCursor(Qt::BlankCursor));
}
