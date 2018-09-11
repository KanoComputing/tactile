/**
 * tactile.qml
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Main window of the application.
 */


import QtQuick 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2

import Tactile.Terminal 1.0

import 'flow.js' as FlowJS


ApplicationWindow {
    id: main_window
    flags: Qt.FramelessWindowHint
    visible: true
    color: "transparent"

    /* width and height are needed for Mac OS, harmless on the RPi */
    width: 1280
    height: 768

    /* variables to hide and restore application position on the screen */
    property int onscreen_x: 0
    property int onscreen_y: 0
    property int offscreen_x: 4000
    property int offscreen_y: 4000

    property int overscan_value: 0

    property int overscan_top: overscan_value
    property int overscan_bottom: overscan_value
    property int overscan_left: overscan_value
    property int overscan_right: overscan_value

    Rectangle {
        id: border
        width: parent.width
        height: parent.height

        Flickable {
            z: 1
            id: scroll
            anchors.fill: parent
            contentY: Math.max(contentHeight - height, 0)

            anchors.topMargin: overscan_top
            anchors.bottomMargin: overscan_bottom
            anchors.leftMargin: overscan_left
            anchors.rightMargin: overscan_right

            contentWidth: flow_loader.width
            contentHeight: flow_loader.height
            interactive: false

            Loader {
                property var background: bg_loader
                property alias overscan_value: main_window.overscan_value
                id: flow_loader
                width: scroll.width
                height: Math.max(scroll.height, item.implicitHeight)
            }
        }

        Loader {
            property string source: TerminalSettings.bg_source
            property color color: TerminalSettings.bg_color

            readonly property url system_wallpaper_path:
                Qt.platform.os == 'linux' ?
                    '/usr/share/kano-desktop/wallpapers/' :
                    // Try location of likely kano-desktop repo checkout
                    '../../../../kano-desktop/wallpapers/'

            function get_wallpaper_aspect_ratio() {
                var ratio;

                if (width <= 1024) {
                    return '1024'
                }

                ratio = main_window.width / main_window.height

                switch (ratio) {
                case 4 / 3:
                    return '4-3';
                case 16 / 9:
                case 16 / 10:
                default:
                    return '16-9';
                }
            }
            readonly property string wallpaper_aspect_ratio: get_wallpaper_aspect_ratio()
            function set_system_wallpaper(wallpaper) {
                bg_loader.source = system_wallpaper_path + wallpaper + '-' + wallpaper_aspect_ratio + '.png';
            }

            id: bg_loader
            anchors.fill: parent

            Component {
                id: img
                Image {
                    source: bg_loader.source
                }
            }
            Component {
                id: colour
                Rectangle {
                    color: bg_loader.color
                }
            }

            sourceComponent: bg_loader.source ? img : colour
        }
    }

    Component.onCompleted: FlowJS.run(flow_loader)
}
