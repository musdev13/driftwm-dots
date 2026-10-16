pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root

    readonly property var notifications: server.trackedNotifications

    NotificationServer {
        id: server
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true

        onNotification: function(notification) {
            notification.tracked = true;

            var actionsDump = [];
            if (notification.actions) {
                for (var i = 0; i < notification.actions.length; i++) {
                    var a = notification.actions[i];
                    actionsDump.push({ text: a.text, identifier: a.identifier });
                }
            }

            console.log("NOTIF DUMP:", JSON.stringify({
                appName: notification.appName,
                appIcon: notification.appIcon,
                summary: notification.summary,
                body: notification.body,
                image: notification.image,
                urgency: notification.urgency,
                hasActionIcons: notification.hasActionIcons,
                actionsCount: actionsDump.length,
                actions: actionsDump,
                hasInlineReply: notification.hasInlineReply,
                inlineReplyPlaceholder: notification.inlineReplyPlaceholder
            }));
        }
    }

    function dismiss(notification) {
        notification.dismiss();
    }

    function dismissAll() {
        var list = root.notifications.values;
        for (var i = 0; i < list.length; i++)
            list[i].dismiss();
    }
}
