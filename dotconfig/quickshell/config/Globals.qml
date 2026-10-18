pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property color panelColor: "#202020"
    property color clockColor: "#ffffff"
    property int clockSize: 16

    property color taskbarItemBg: "#00000000"
    property color taskbarItemHoverBg: "#33ffffff"
    property color taskbarItemActiveBg: "#55ffffff"
    property color taskbarIconColor: "#ffffff"
    property int taskbarItemSize: 38
    property int taskbarItemSpacing: 4

    property color dividerColor: "#55ffffff"
    property int dividerWidth: 2
    property int dividerHeight: 18

    property int trayItemSize: 24
    property int trayItemSpacing: 4
    property color trayItemHoverBg: "#33ffffff"

    property int panelRowSpacing: 8

    property color widgetTextColor: "#ffffff"
    property string widgetFontFamily: "JetBrainsMono Nerd Font"
    property int widgetFontSize: 14
    property int barPadding: 24

    property color batteryLowColor: "#ff5555"
    property color batteryMediumColor: "#f1fa8c"
    property color batteryHighColor: "#50fa7b"

    property color audioMutedColor: "#ff5555"

    property color groupBgColor: "#12efffff"
    property int groupRadius: 8
    property int groupPaddingH: 10
    property int groupPaddingV: 6
    property int groupSpacing: 8

    property int notifWidth: 360
    property int notifSpacing: 8
    property int notifPadding: 12
    property int notifMargin: 8
    property color notifBgColor: "#e6202020"
    property color notifTitleColor: "#ffffff"
    property color notifBodyColor: "#cccccc"
    property color notifAppNameColor: "#888888"
    property int notifRadius: 8
    property int notifTimeout: 5000
    property int notifAnimationDuration: 200

    property int notifAppIconSize: 20
    property int notifImageRadius: 6
    property int notifImageMaxHeight: 180

    property color notifButtonBg: "#33ffffff"
    property color notifButtonHoverBg: "#55ffffff"
    property color notifButtonTextColor: "#ffffff"
    property int notifButtonRadius: 6
    property int notifButtonPaddingH: 12
    property int notifButtonPaddingV: 6
    property int notifButtonSpacing: 6

    property color notifReplyBg: "#33ffffff"
    property color notifReplyTextColor: "#ffffff"
    property color notifReplyPlaceholderColor: "#888888"
    property int notifReplyRadius: 6
    property int notifReplyPadding: 8

    property color notifCloseHoverColor: "#ff5555"

    property color lockBgColor: "#121212"
    property color lockTextColor: "#ffffff"
    property color lockSubtextColor: "#888888"
    property color lockErrorColor: "#ff5555"
    property int lockClockSize: 120
    property int lockDateSize: 18
    property int lockSpacing: 32

    property color lockFieldLineColor: "#44ffffff"
    property color lockFieldLineActiveColor: "#ffffff"
    property color lockFieldTextColor: "#ffffff"
    property int lockFieldWidth: 300
    property int lockFieldHeight: 44
    property int lockFieldFontSize: 16

    property int mediaCoverSize: 24
    property int mediaCoverRadius: 4
    property int mediaMaxTextWidth: 150
    property color mediaSubtextColor: "#a0a0a0"
    property int mediaSubtextSize: 12

    property int mediaPopupWidth: 320
    property int mediaPopupPadding: 16
    property int mediaPopupRadius: 12
    property color mediaPopupBgColor: "#e6202020"
    property int mediaPopupCoverSize: 96
    property int mediaPopupTitleSize: 16
    property int mediaPopupArtistSize: 14
    property int mediaPopupSpacing: 12

    property color mediaProgressBgColor: "#44ffffff"
    property color mediaProgressFillColor: "#ffffff"
    property int mediaProgressHeight: 4
    property int mediaProgressHandleSize: 10

    property color mediaButtonColor: "#ffffff"
    property color mediaButtonHoverColor: "#88ffffff"
    property int mediaButtonSize: 24
    property int mediaButtonIconSize: 20
}
