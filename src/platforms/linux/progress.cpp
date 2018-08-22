/**
 * progress.cpp
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Allows the progress through the flow to be logged so the user can
 * continue where they finished off should they unplug before the end
 *
 * Supplemented by the general c++ file.
 */


#include "progress.h"
#include "../common/progress_base.cpp"


const QDir Progress::STATE_DIR = QDir("/var/lib/tactile");
const QString Progress::STATE_FILE_NAME = "progress";
const QFileInfo Progress::STATE_FILE = QFileInfo(
    Progress::STATE_DIR, Progress::STATE_FILE_NAME
);
