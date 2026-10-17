import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import "../../config" as Config

Text {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    property bool isHeadphones: false

    function toggleMute() {
        if (root.sink && root.sink.audio)
            root.sink.audio.muted = !root.sink.audio.muted;
    }

    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [ Pipewire.defaultAudioSink ] : []
    }

    Process {
        id: portProc
        command: ["pactl", "get-sink-port", "@DEFAULT_SINK@"]

        stdout: SplitParser {
            onRead: function(line) {
                root.isHeadphones = line.indexOf("headphone") !== -1;
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: portProc.running = true
    }

    onSinkChanged: portProc.running = true

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
        onClicked: root.toggleMute()
    }
}
