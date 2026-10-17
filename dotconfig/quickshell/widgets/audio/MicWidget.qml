import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../../config" as Config

Text {
    id: root

    readonly property var source: Pipewire.defaultAudioSource
    readonly property bool muted: source && source.audio ? source.audio.muted : false
    readonly property real volume: source && source.audio ? source.audio.volume : 0

    function toggleMute() {
        if (root.source && root.source.audio)
            root.source.audio.muted = !root.source.audio.muted;
    }

    PwObjectTracker {
        objects: Pipewire.defaultAudioSource ? [ Pipewire.defaultAudioSource ] : []
    }

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
        onClicked: root.toggleMute()
    }
}
