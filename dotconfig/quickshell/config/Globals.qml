pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property color panelColor: "#202020"
    property color clockColor: "#ffffff"

    // Taskbar
    property color taskbarItemBg: "#00000000"
    property color taskbarItemHoverBg: "#33ffffff"
    property color taskbarItemActiveBg: "#55ffffff"
    property color taskbarIconColor: "#ffffff"
    property int taskbarItemSize: 32
    property int taskbarItemSpacing: 4
}