import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config" as Config

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: Config.Globals.taskbarItemSize

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Config.Globals.taskbarItemSpacing

        Repeater {
            model: ToplevelManager.toplevels.values

            TaskbarItem {
                required property Toplevel modelData
                toplevel: modelData
            }
        }
    }
}
