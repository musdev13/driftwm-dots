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

    spacing: Config.Globals.trayItemSpacing

    Repeater {
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
                source: trayItem.modelData.icon_name
                    ? Quickshell.iconPath(trayItem.modelData.icon_name, true)
                    : ""
                sourceSize.width: width
                sourceSize.height: height
                smooth: true
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: trayMouse
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                onClicked: function(mouse) {
                    var addr = trayItem.modelData.address;
                    if (mouse.button === Qt.LeftButton)
                        Services.Mshelld.trayActivate(addr);
                    else if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.has_menu) {
                            root.menuAnchorItem = trayItem;
                            root.menuAddress = addr;
                            root.menuEntries = trayItem.modelData.menu;
                            menu.open();
                        }
                    } else if (mouse.button === Qt.MiddleButton)
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
    }
}
