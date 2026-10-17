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
    property var _submenuEntries: []
    property alias containsMouse: hoverHandler.hovered

    function open() {
        _submenuEntries = [];
        visible = true;
    }
    function close() { visible = false; }

    visible: false
    color: "transparent"
    grabFocus: false

    anchor.window: panelWindow
    anchor.rect.x: anchorItem ? anchorItem.mapToItem(null, 0, 0).x : 0
    anchor.rect.y: -(contentRect.implicitHeight + 4)
    anchor.rect.width: anchorItem ? anchorItem.width : 0
    anchor.rect.height: anchorItem ? anchorItem.height : 0

    implicitWidth: contentRect.implicitWidth
    implicitHeight: contentRect.implicitHeight

    Rectangle {
        id: contentRect
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        implicitWidth: rowLayout.implicitWidth + 16
        implicitHeight: rowLayout.implicitHeight + 8
        color: "#e6202020"
        radius: 8

        HoverHandler {
            id: hoverHandler
        }

        Row {
            id: rowLayout
            anchors.centerIn: parent
            spacing: 4

            TrayMenuList {
                id: level0
                entries: root.entries
                onItemHovered: function(entry) {
                    root._submenuEntries = (entry.children && entry.children.length > 0) ? entry.children : [];
                }
                onItemClicked: function(id) {
                    Services.Mshelld.trayMenuClick(root.address, id);
                    root.close();
                }
            }

            Rectangle {
                visible: root._submenuEntries.length > 0
                width: 1
                height: level0.implicitHeight
                color: "#33ffffff"
            }

            TrayMenuList {
                id: level1
                visible: root._submenuEntries.length > 0
                entries: root._submenuEntries
                onItemClicked: function(id) {
                    Services.Mshelld.trayMenuClick(root.address, id);
                    root.close();
                }
            }
        }
    }
}
