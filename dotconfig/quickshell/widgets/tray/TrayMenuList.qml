import QtQuick
import Quickshell
import "../../config" as Config

Column {
    id: root

    property var entries: []
    property int hoveredId: -1

    signal itemClicked(int id)
    signal itemHovered(var entry)

    spacing: 2

    function resetHover() { hoveredId = -1; }

    Repeater {
        model: root.entries

        Item {
            required property var modelData

            width: implicitWidth
            implicitWidth: modelData.item_type === "Separator" ? 40 : (contentRow.implicitWidth + 16)
            height: modelData.item_type === "Separator" ? 9 : (contentRow.implicitHeight + 6)

            Rectangle {
                visible: modelData.item_type === "Separator"
                anchors.centerIn: parent
                width: parent.width - 16
                height: 1
                color: "#33ffffff"
            }

            Rectangle {
                visible: modelData.item_type !== "Separator"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                radius: 4
                color: (root.hoveredId === modelData.id && modelData.enabled) ? "#33ffffff" : "transparent"
                opacity: 0.8
                z: -1
            }

            Row {
                id: contentRow
                visible: modelData.item_type !== "Separator"
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6
                opacity: modelData.enabled ? 1.0 : 0.4

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 14
                    height: 14
                    source: modelData.icon_name && modelData.icon_name.length > 0
                        ? Quickshell.iconPath(modelData.icon_name, true)
                        : ""
                    visible: source != ""
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.label || ""
                    color: Config.Globals.widgetTextColor
                    font.family: Config.Globals.widgetFontFamily
                    font.pixelSize: Config.Globals.widgetFontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\u{f054}"
                    font.family: Config.Globals.widgetFontFamily
                    font.pixelSize: Config.Globals.widgetFontSize - 4
                    color: Config.Globals.widgetTextColor
                    opacity: 0.6
                    visible: modelData.children && modelData.children.length > 0
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                enabled: modelData.item_type !== "Separator" && modelData.enabled
                cursorShape: modelData.children && modelData.children.length > 0
                    ? Qt.ArrowCursor
                    : Qt.PointingHandCursor

                onEntered: {
                    root.hoveredId = modelData.id;
                    root.itemHovered(modelData);
                }

                onClicked: {
                    if (modelData.children && modelData.children.length > 0)
                        return;
                    root.itemClicked(modelData.id);
                }
            }
        }
    }
}
