import QtQuick
import Quickshell
import "../../config" as Config
import "../../services" as Services

PopupWindow {
    id: root

    property var panelWindow
    property var anchorItem
    property string address: ""
    property var entries: []

    function open() { visible = true; }
    function close() { visible = false; }

    visible: false
    color: "transparent"
    grabFocus: true

    anchor.window: panelWindow
    anchor.rect.x: anchorItem ? anchorItem.mapToItem(null, 0, 0).x : 0
    anchor.rect.y: anchorItem ? anchorItem.mapToItem(null, 0, 0).y - implicitHeight - 4 : 0
    anchor.rect.width: anchorItem ? anchorItem.width : 0
    anchor.rect.height: anchorItem ? anchorItem.height : 0
    anchor.edges: Edges.Bottom

    implicitWidth: contentRect.implicitWidth
    implicitHeight: contentRect.implicitHeight

    Rectangle {
        id: contentRect
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        implicitWidth: column.implicitWidth + 16
        implicitHeight: column.implicitHeight + 8
        color: "#e6202020"
        radius: 8

        Column {
            id: column
            anchors.centerIn: parent
            spacing: 2

            Repeater {
                model: root.entries

                Rectangle {
                    required property var modelData

                    implicitWidth: labelText.implicitWidth + 16
                    implicitHeight: labelText.implicitHeight + 4
                    radius: 4
                    color: itemMouse.containsMouse ? "#33ffffff" : "transparent"
                    opacity: modelData.enabled ? 1.0 : 0.4

                    Text {
                        id: labelText
                        anchors.centerIn: parent
                        text: modelData.label || ""
                        color: Config.Globals.widgetTextColor
                        font.family: Config.Globals.widgetFontFamily
                        font.pixelSize: Config.Globals.widgetFontSize
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: modelData.enabled
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Services.Mshelld.trayMenuClick(root.address, modelData.id);
                            root.close();
                        }
                    }
                }
            }
        }
    }
}
