import QtQuick
import Quickshell
import "../../config" as Config
import "../../services" as Services

Text {
    id: root

    readonly property var source: Services.Mshelld.audio.source
    readonly property bool muted: source ? source.muted : false
    readonly property real volume: source ? source.volume : 0

    text: {
        if (muted)
            return "\u{f131}";
        return "\u{f130}" + " " + Math.round(volume * 100) + "%";
    }

    color: muted ? Config.Globals.audioMutedColor : Config.Globals.widgetTextColor
    font.family: Config.Globals.widgetFontFamily
    font.pixelSize: Config.Globals.widgetFontSize

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Services.Mshelld.toggleSourceMute()
    }
}
