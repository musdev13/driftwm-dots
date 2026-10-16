pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property color panelColor: "#202020"
    property color clockColor: "#ffffff"

    property color taskbarItemBg: "#00000000"
    property color taskbarItemHoverBg: "#33ffffff"
    property color taskbarItemActiveBg: "#55ffffff"
    property color taskbarIconColor: "#ffffff"
    property int taskbarItemSize: 32
    property int taskbarItemSpacing: 4

    property color dividerColor: "#55ffffff"
    property int dividerWidth: 1
    property int dividerHeight: 24

    property int trayItemSize: 24
    property int trayItemSpacing: 4
    property color trayItemHoverBg: "#33ffffff"

    property int panelRowSpacing: 8

    property color widgetTextColor: "#ffffff"
    property string widgetFontFamily: "JetBrainsMono Nerd Font"
    property int widgetFontSize: 14
    property int barPadding: 12

    property color batteryLowColor: "#ff5555"
    property color batteryMediumColor: "#f1fa8c"
    property color batteryHighColor: "#50fa7b"
}
