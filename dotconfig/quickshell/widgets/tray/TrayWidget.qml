import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../../config" as Config

Row {
    id: root

    property var panelWindow

    spacing: Config.Globals.trayItemSpacing

    Repeater {
        model: SystemTray.items

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
                source: trayItem.modelData.icon
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
                    if (mouse.button === Qt.LeftButton)
                        trayItem.modelData.activate();
                    else if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.hasMenu)
                            menu.open();
                    } else if (mouse.button === Qt.MiddleButton)
                        trayItem.modelData.secondaryActivate();
                }
            }

            QsMenuAnchor {
                id: menu
                menu: trayItem.modelData.menu
                anchor.window: root.panelWindow
                anchor.rect.x: trayItem.mapToItem(null, 0, 0).x
                anchor.rect.y: trayItem.mapToItem(null, 0, 0).y
                anchor.rect.width: trayItem.width
                anchor.rect.height: trayItem.height
                anchor.edges: Edges.Top
            }
        }
    }
}
