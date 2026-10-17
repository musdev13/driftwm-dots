import QtQuick
import Quickshell
import "../../config" as Config
import "../../services" as Services

Text {
    id: root

    readonly property var sink: Services.Mshelld.audio.sink
    readonly property bool muted: sink ? sink.muted : false
    readonly property real volume: sink ? sink.volume : 0
    readonly property bool isHeadphones: sink && sink.device === "headphones"

    text: {
        if (muted)
            return "\u{f026}";
        var icon = isHeadphones ? "\u{f025}" : "\u{f028}";
        return icon + "  " + Math.round(volume * 100) + "%";
    }

    color: muted ? Config.Globals.audioMutedColor : Config.Globals.widgetTextColor
    font.family: Config.Globals.widgetFontFamily
    font.pixelSize: Config.Globals.widgetFontSize

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Services.Mshelld.toggleSinkMute()
    }
}
