import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "../../config"

PopupWindow {
    id: popup
    property MprisPlayer player: null
    property Item targetItem: null
    property bool popupHovered: false

    anchor.item: targetItem
    anchor.rect.x: (targetItem.width - implicitWidth) / 2
    anchor.rect.y: targetItem.height + 8

    implicitWidth: Globals.mediaPopupWidth
    implicitHeight: contentLayout.implicitHeight + Globals.mediaPopupPadding * 2
    color: "transparent"
    visible: false

    HoverHandler {
        onHoveredChanged: popup.popupHovered = hovered
    }

    Rectangle {
        anchors.fill: parent
        color: Globals.mediaPopupBgColor
        radius: Globals.mediaPopupRadius
    }

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: Globals.mediaPopupPadding
        spacing: Globals.mediaPopupSpacing

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: Globals.mediaPopupCoverSize
            implicitHeight: Globals.mediaPopupCoverSize
            radius: Globals.mediaCoverRadius
            color: "transparent"
            clip: true

            Image {
                anchors.fill: parent
                source: popup.player ? popup.player.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: popup.player ? popup.player.trackTitle : "No Media"
                color: Globals.widgetTextColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.mediaPopupTitleSize
                font.bold: true
                elide: Text.ElideRight
                Layout.maximumWidth: Globals.mediaPopupWidth - Globals.mediaPopupPadding * 2
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: popup.player ? popup.player.trackArtist : ""
                color: Globals.mediaSubtextColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.mediaPopupArtistSize
                elide: Text.ElideRight
                Layout.maximumWidth: Globals.mediaPopupWidth - Globals.mediaPopupPadding * 2
                visible: text.length > 0
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Globals.mediaProgressHandleSize

            Rectangle {
                id: progressBg
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: Globals.mediaProgressHeight
                radius: Globals.mediaProgressHeight / 2
                color: Globals.mediaProgressBgColor
            }

            Rectangle {
                id: progressFill
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * (popup.player && popup.player.length > 0 ? (popup.player.position / popup.player.length) : 0)
                height: Globals.mediaProgressHeight
                radius: Globals.mediaProgressHeight / 2
                color: Globals.mediaProgressFillColor
            }

            Rectangle {
                id: progressHandle
                anchors.verticalCenter: parent.verticalCenter
                width: Globals.mediaProgressHandleSize
                height: Globals.mediaProgressHandleSize
                radius: Globals.mediaProgressHandleSize / 2
                color: Globals.mediaProgressFillColor
                x: progressFill.width - width / 2
                visible: popup.player && popup.player.length > 0
            }

            MouseArea {
                anchors.fill: progressBg
                cursorShape: Qt.PointingHandCursor
                onPressed: (mouse) => {
                    if (popup.player && popup.player.length > 0) {
                        var p = Math.max(0, Math.min(1, mouse.x / progressBg.width));
                        popup.player.position = p * popup.player.length;
                    }
                }
                onPositionChanged: (mouse) => {
                    if (pressed && popup.player && popup.player.length > 0) {
                        var p = Math.max(0, Math.min(1, mouse.x / progressBg.width));
                        popup.player.position = p * popup.player.length;
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24

            Text {
                text: "󰒮"
                color: Globals.mediaButtonColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.mediaButtonIconSize
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (popup.player) popup.player.previous()
                }
            }

            Text {
                text: (popup.player && popup.player.isPlaying) ? "󰏤" : "󰐊"
                color: Globals.mediaButtonColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.mediaButtonIconSize
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (popup.player) popup.player.togglePlaying()
                }
            }

            Text {
                text: "󰒭"
                color: Globals.mediaButtonColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.mediaButtonIconSize
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -8
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (popup.player) popup.player.next()
                }
            }
        }
    }
}
