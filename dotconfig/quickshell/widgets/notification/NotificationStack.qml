import QtQuick
import "../../config" as Config
import "../../services" as Services

Column {
    id: root

    spacing: Config.Globals.notifSpacing
    width: Config.Globals.notifWidth

    Repeater {
        model: Services.NotificationService.notifications.values

        NotificationItem {
            required property var modelData
            notification: modelData
            width: root.width
        }
    }
}
