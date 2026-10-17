import Quickshell
import QtQuick
import "../config"
import "../services" as Services
import "../widgets/notification"

PopupWindow {
    id: root

    property var panelWindow
    property int panelHeight: 48

    anchor.window: panelWindow
    anchor.rect.x: 0
    anchor.rect.y: panelHeight
    anchor.edges: Edges.Bottom

    visible: Services.Mshelld.notifications.length > 0

    implicitWidth: Globals.notifWidth
    implicitHeight: stack.implicitHeight

    color: "transparent"

    NotificationStack {
        id: stack
        anchors.left: parent.left
        anchors.top: parent.top
    }
}
