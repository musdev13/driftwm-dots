import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config" as Config

Rectangle {
    id: root

    required property Toplevel toplevel

    readonly property var desktopEntry: {
        let appId = root.toplevel.appId;
        if (!appId) return null;

        let entry = DesktopEntries.heuristicLookup(appId);
        if (entry) return entry;

        let apps = DesktopEntries.applications.values;
        for (let i = 0; i < apps.length; i++) {
            let app = apps[i];

            if (app.startupClass && app.startupClass === appId)
                return app;

            if (app.id === appId)
                return app;

            if (app.execString && app.execString.length > 0) {
                let execName = app.execString[0].split('/').pop();
                if (execName === appId)
                    return app;
            }

            if (app.name && app.name.toLowerCase() === appId.toLowerCase())
                return app;
        }

        return null;
    }

    readonly property string iconName: {
        if (desktopEntry && desktopEntry.icon && desktopEntry.icon.length > 0)
            return desktopEntry.icon;
        return root.toplevel.appId;
    }

    implicitWidth: Config.Globals.taskbarItemSize
    implicitHeight: Config.Globals.taskbarItemSize
    radius: 6
    color: mouseArea.containsMouse
        ? Config.Globals.taskbarItemHoverBg
        : (root.toplevel.activated ? Config.Globals.taskbarItemActiveBg : Config.Globals.taskbarItemBg)

    Image {
        id: icon
        anchors.centerIn: parent
        width: Config.Globals.taskbarItemSize - 12
        height: Config.Globals.taskbarItemSize - 12
        source: Quickshell.iconPath(root.iconName, "application-x-executable")
        sourceSize.width: width
        sourceSize.height: height
        smooth: true
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton)
                root.toplevel.activate();
            else if (mouse.button === Qt.MiddleButton)
                root.toplevel.close();
        }
    }
}
