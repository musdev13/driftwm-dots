import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "../../config"

Item {
    id: root
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    property MprisPlayer player: {
        var playing = null;
        var first = null;
        for (var i = 0; i < Mpris.players.values.length; i++) {
            var p = Mpris.players.values[i];
            if (!first) first = p;
            if (p.isPlaying) {
                playing = p;
                break;
            }
        }
        return playing || first;
    }

    property real displayPosition: 0
    property bool hasTrack: player !== null && player.trackTitle !== ""

    onPlayerChanged: displayPosition = player ? player.position : 0

    Connections {
        target: root.player
        function onPositionChanged() {
            root.displayPosition = root.player.position;
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.player && root.player.isPlaying
        onTriggered: {
            if (root.displayPosition < root.player.length || root.player.length === 0) {
                root.displayPosition += 1;
            }
        }
    }

    function formatTime(sec) {
        if (sec === undefined || sec === null || sec < 0) return "0:00";
        var m = Math.floor(sec / 60);
        var s = Math.floor(sec % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    HoverHandler {
        id: hoverHandler
    }

    property bool isHovered: hoverHandler.hovered || popup.popupHovered
    property bool popupVisible: false

    onIsHoveredChanged: {
        if (isHovered) {
            hideTimer.stop();
            popupVisible = true;
        } else {
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 300
        onTriggered: {
            if (!root.isHovered) {
                root.popupVisible = false;
            }
        }
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: Globals.panelRowSpacing

        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: Globals.mediaCoverSize
            implicitHeight: Globals.mediaCoverSize
            radius: Globals.mediaCoverRadius
            color: "transparent"
            clip: true

            Image {
                id: cover
                anchors.fill: parent
                source: (root.player && root.player.trackArtUrl) ? root.player.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }

            Text {
                anchors.centerIn: parent
                text: "󰎆"
                font.family: Globals.widgetFontFamily
                color: Globals.widgetTextColor
                visible: !cover.visible
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                text: root.hasTrack ? root.player.trackTitle : "No Media"
                color: Globals.widgetTextColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.widgetFontSize
                elide: Text.ElideRight
                Layout.maximumWidth: Globals.mediaMaxTextWidth
            }

            Text {
                text: root.hasTrack ? root.player.trackArtist : ""
                color: Globals.mediaSubtextColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.mediaSubtextSize
                elide: Text.ElideRight
                Layout.maximumWidth: Globals.mediaMaxTextWidth
                visible: text.length > 0
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: root.formatTime(root.displayPosition) + " / " + (root.player ? root.formatTime(root.player.length) : "0:00")
            color: Globals.mediaSubtextColor
            font.family: Globals.widgetFontFamily
            font.pixelSize: Globals.mediaSubtextSize
        }
    }

    MediaPopup {
        id: popup
        player: root.player
        targetItem: root
        visible: root.popupVisible
    }
}
