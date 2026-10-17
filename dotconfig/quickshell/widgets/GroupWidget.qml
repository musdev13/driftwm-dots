import QtQuick
import "../config" as Config

Rectangle {
    id: root

    default property alias content: row.data

    property int spacing: Config.Globals.groupSpacing
    property int paddingH: Config.Globals.groupPaddingH
    property int paddingV: Config.Globals.groupPaddingV

    implicitWidth: row.implicitWidth + paddingH * 2
    implicitHeight: row.implicitHeight + paddingV * 2

    color: Config.Globals.groupBgColor
    radius: Config.Globals.groupRadius

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.spacing
    }
}
