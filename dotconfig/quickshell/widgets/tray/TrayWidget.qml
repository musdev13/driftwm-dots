import QtQuick
import Quickshell
import "../../config" as Config
import "../../services" as Services
import "TrayMenu.qml"

Row {
    id: root

    property var panelWindow
    property var menuAnchorItem: null
    property string menuAddress: ""
    property var menuEntries: []
    property string _hoverAddress: ""

    spacing: Config.Globals.trayItemSpacing

    Timer {
        id: openTimer
        interval: 250
        repeat: false
        onTriggered: {
            if (!root._hoverAddress) return;
            for (var i = 0; i < itemsRepeater.count; i++) {
                var it = itemsRepeater.itemAt(i);
                if (it && it.modelData && it.modelData.address === root._hoverAddress) {
                    if (!it.modelData.has_menu) return;
                    root.menuAnchorItem = it;
                    root.menuAddress = it.modelData.address;
                    root.menuEntries = it.modelData.menu;
                    menu.open();
                    return;
                }
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 400
        repeat: false
        onTriggered: {
            if (menu.containsMouse) return;
            if (root._hoverAddress !== "") return;
            menu.close();
        }
    }

    Repeater {
        id: itemsRepeater
        model: Services.Mshelld.trayItems

        Rectangle {
            id: trayItem

            required property var modelData

            implicitWidth: Config.Globals.trayItemSize
            implicitHeight: Config.Globals.trayItemSize
            radius: 4
            color: trayMouse.containsMouse ? Config.Globals.trayItemHoverBg : "transparent"

            Image {
                anchors.centerIn: parent
                width: Config.Globals.trayItemSize - 6
                height: Config.Globals.trayItemSize - 6
                source: {
                    var item = trayItem.modelData;
                    if (item.icon_name && item.icon_name.length > 0)
                        return Quickshell.iconPath(item.icon_name, true);
                    if (item.icon_pixmap_path && item.icon_pixmap_path.length > 0)
                        return "file://" + item.icon_pixmap_path + "?v=" + item.address;
                    return "";
                }
                sourceSize.width: width
                sourceSize.height: height
                smooth: true
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: trayMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton

                onEntered: {
                    root._hoverAddress = trayItem.modelData.address;
                    closeTimer.stop();
                    if (trayItem.modelData.has_menu)
                        openTimer.restart();
                }

                onExited: {
                    if (root._hoverAddress === trayItem.modelData.address)
                        root._hoverAddress = "";
                    openTimer.stop();
                    closeTimer.restart();
                }

                onClicked: function(mouse) {
                    var addr = trayItem.modelData.address;
                    if (mouse.button === Qt.LeftButton)
                        Services.Mshelld.trayActivate(addr);
                    else if (mouse.button === Qt.MiddleButton)
                        Services.Mshelld.traySecondaryActivate(addr);
                }
            }
        }
    }

    TrayMenu {
        id: menu
        panelWindow: root.panelWindow
        anchorItem: root.menuAnchorItem
        address: root.menuAddress
        entries: root.menuEntries

        onContainsMouseChanged: {
            if (containsMouse) {
                closeTimer.stop();
            } else if (root._hoverAddress === "") {
                closeTimer.restart();
            }
        }
    }
}
