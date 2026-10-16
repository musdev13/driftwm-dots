import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import "../../config" as Config

Item {
    id: root

    required property var notification

    readonly property int urgency: notification.urgency
    readonly property bool hasImage: notification.image && notification.image.length > 0
    readonly property bool hasActions: notification.actions && notification.actions.length > 0
    readonly property bool hasReply: notification.hasInlineReply

    property real dragOffset: 0

    implicitWidth: Config.Globals.notifWidth
    implicitHeight: card.implicitHeight
    opacity: 1 - Math.min(1, Math.abs(dragOffset) / Math.max(1, width))

    Rectangle {
        id: card
        anchors.fill: parent
        transform: Translate { x: root.dragOffset }
        radius: Config.Globals.notifRadius
        color: Config.Globals.notifBgColor
        border.width: root.urgency === NotificationUrgency.Critical ? 1 : 0
        border.color: Config.Globals.batteryLowColor

        implicitHeight: content.implicitHeight + Config.Globals.notifPadding * 2

        Timer {
            interval: root.notification.expireTimeout > 0
                ? root.notification.expireTimeout
                : Config.Globals.notifTimeout
            running: root.urgency !== NotificationUrgency.Critical && !dragHandler.active
            repeat: false
            onTriggered: root.notification.dismiss()
        }

        ColumnLayout {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Config.Globals.notifPadding
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Image {
                    Layout.preferredWidth: Config.Globals.notifAppIconSize
                    Layout.preferredHeight: Config.Globals.notifAppIconSize
                    Layout.alignment: Qt.AlignVCenter
                    source: root.notification.appIcon && root.notification.appIcon.length > 0
                        ? Quickshell.iconPath(root.notification.appIcon, "dialog-information")
                        : ""
                    sourceSize.width: Config.Globals.notifAppIconSize
                    sourceSize.height: Config.Globals.notifAppIconSize
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    visible: source != ""
                }

                Text {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    text: root.notification.appName || ""
                    color: Config.Globals.notifAppNameColor
                    font.family: Config.Globals.widgetFontFamily
                    font.pixelSize: Config.Globals.widgetFontSize - 2
                    elide: Text.ElideRight
                }

                Text {
                    id: closeButton
                    Layout.alignment: Qt.AlignVCenter
                    text: "\u{f00d}"
                    color: closeMouse.containsMouse
                        ? Config.Globals.notifCloseHoverColor
                        : Config.Globals.notifAppNameColor
                    font.family: Config.Globals.widgetFontFamily
                    font.pixelSize: Config.Globals.widgetFontSize

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        anchors.margins: -4
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.notification.dismiss()
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    visible: root.hasImage
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignTop
                    radius: width / 2
                    clip: true
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        source: root.notification.image
                        sourceSize.width: 40
                        sourceSize.height: 40
                        fillMode: Image.PreserveAspectCrop
                        smooth: true
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.summary || ""
                        color: Config.Globals.notifTitleColor
                        font.family: Config.Globals.widgetFontFamily
                        font.pixelSize: Config.Globals.widgetFontSize
                        font.bold: true
                        wrapMode: Text.Wrap
                        visible: text.length > 0
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.body || ""
                        textFormat: Text.PlainText
                        color: Config.Globals.notifBodyColor
                        font.family: Config.Globals.widgetFontFamily
                        font.pixelSize: Config.Globals.widgetFontSize - 1
                        wrapMode: Text.Wrap
                        visible: text.length > 0
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.Globals.notifButtonSpacing
                visible: root.hasActions

                Repeater {
                    model: root.notification.actions || []

                    Rectangle {
                        id: actionBtn

                        required property var modelData

                        Layout.preferredWidth: actionText.implicitWidth + Config.Globals.notifButtonPaddingH * 2
                        Layout.preferredHeight: actionText.implicitHeight + Config.Globals.notifButtonPaddingV * 2
                        radius: Config.Globals.notifButtonRadius
                        color: actionMouse.containsMouse
                            ? Config.Globals.notifButtonHoverBg
                            : Config.Globals.notifButtonBg

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: actionBtn.modelData.text || ""
                            color: Config.Globals.notifButtonTextColor
                            font.family: Config.Globals.widgetFontFamily
                            font.pixelSize: Config.Globals.widgetFontSize - 2
                        }

                        MouseArea {
                            id: actionMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: actionBtn.modelData.invoke()
                        }
                    }
                }

                Item { Layout.fillWidth: true }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: replyField.implicitHeight + Config.Globals.notifReplyPadding * 2
                radius: Config.Globals.notifReplyRadius
                color: Config.Globals.notifReplyBg
                visible: root.hasReply

                TextField {
                    id: replyField
                    anchors.fill: parent
                    anchors.margins: Config.Globals.notifReplyPadding
                    placeholderText: root.notification.inlineReplyPlaceholder || "Reply..."
                    placeholderTextColor: Config.Globals.notifReplyPlaceholderColor
                    color: Config.Globals.notifReplyTextColor
                    font.family: Config.Globals.widgetFontFamily
                    font.pixelSize: Config.Globals.widgetFontSize - 2
                    background: null
                    selectByMouse: true

                    onAccepted: {
                        if (text.length > 0) {
                            root.notification.sendInlineReply(text);
                            text = "";
                        }
                    }
                }
            }
        }

        DragHandler {
            id: dragHandler
            target: null
            xAxis.enabled: true
            yAxis.enabled: false

            onTranslationChanged: {
                root.dragOffset = activeTranslation.x;
            }

            onActiveChanged: {
                if (!active) {
                    if (Math.abs(root.dragOffset) > root.width * 0.35) {
                        root.notification.dismiss();
                    } else {
                        resetAnim.start();
                    }
                }
            }
        }

        NumberAnimation {
            id: resetAnim
            target: root
            property: "dragOffset"
            to: 0
            duration: 150
            easing.type: Easing.OutCubic
        }
    }
}
