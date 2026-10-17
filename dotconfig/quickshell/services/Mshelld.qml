pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var trayItems: []
    property var audio: ({ sink: { volume: 0, muted: false, device: "speakers" }, source: { volume: 0, muted: false } })
    property var battery: ({ present: false, percentage: 0, state: "" })
    property var notifications: []

    readonly property string socketPath: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/mshelld.sock"

    Socket {
        id: sock
        path: root.socketPath
        connected: true
        parser: SplitParser {
            onRead: function(line) {
                if (!line || line.length === 0)
                    return;
                var msg;
                try {
                    msg = JSON.parse(line);
                } catch (e) {
                    return;
                }
                root._handle(msg);
            }
        }
        onConnectedChanged: {
            if (!connected)
                reconnectTimer.restart();
        }
    }

    Timer {
        id: reconnectTimer
        interval: 2000
        repeat: false
        onTriggered: sock.connected = true
    }

    function _handle(msg) {
        if (msg.type === "tray") {
            if (msg.event === "add") {
                var items = root.trayItems.slice();
                items = items.filter(function(it) { return it.address !== msg.item.address; });
                items.push(msg.item);
                root.trayItems = items;
            } else if (msg.event === "update") {
                var items2 = root.trayItems.slice();
                for (var i = 0; i < items2.length; i++) {
                    if (items2[i].address === msg.item.address) {
                        items2[i] = msg.item;
                        break;
                    }
                }
                root.trayItems = items2;
            } else if (msg.event === "menu") {
                var items3 = root.trayItems.slice();
                for (var j = 0; j < items3.length; j++) {
                    if (items3[j].address === msg.address) {
                        var copy = Object.assign({}, items3[j]);
                        copy.menu = msg.menu;
                        copy.has_menu = msg.menu.length > 0;
                        items3[j] = copy;
                        break;
                    }
                }
                root.trayItems = items3;
            } else if (msg.event === "remove") {
                root.trayItems = root.trayItems.filter(function(it) {
                    return it.address !== msg.address;
                });
            }
        } else if (msg.type === "audio") {
            root.audio = { sink: msg.sink, source: msg.source };
        } else if (msg.type === "battery") {
            root.battery = msg;
        } else if (msg.type === "notification") {
            if (msg.event === "add") {
                var list = root.notifications.slice();
                list = list.filter(function(n) { return n.id !== msg.notification.id; });
                list.push(msg.notification);
                root.notifications = list;
            } else if (msg.event === "update") {
                var list2 = root.notifications.slice();
                for (var k = 0; k < list2.length; k++) {
                    if (list2[k].id === msg.notification.id) {
                        list2[k] = msg.notification;
                        break;
                    }
                }
                root.notifications = list2;
            } else if (msg.event === "close") {
                root.notifications = root.notifications.filter(function(n) {
                    return n.id !== msg.id;
                });
            }
        }
    }

    function send(obj) {
        if (!sock.connected)
            return;
        sock.write(JSON.stringify(obj) + "\n");
        sock.flush();
    }

    function toggleSinkMute() { send({ cmd: "audio.toggleSinkMute" }); }
    function toggleSourceMute() { send({ cmd: "audio.toggleSourceMute" }); }
    function trayActivate(address) { send({ cmd: "tray.activate", address: address, x: 0, y: 0 }); }
    function traySecondaryActivate(address) { send({ cmd: "tray.secondaryActivate", address: address, x: 0, y: 0 }); }
    function trayMenuClick(address, menuId) { send({ cmd: "tray.menuClick", address: address, menu_id: menuId }); }

    function dismissNotification(id) { send({ cmd: "notification.dismiss", id: id }); }
    function invokeNotificationAction(id, key) { send({ cmd: "notification.invokeAction", id: id, key: key }); }
    function replyNotification(id, text) { send({ cmd: "notification.reply", id: id, text: text }); }
}
