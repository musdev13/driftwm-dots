import Quickshell
import QtQuick
import "../config"
import "../widgets/taskbar"

PanelWindow {
    color: Globals.panelColor

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: 48

    TaskbarWidget {
        anchors.centerIn: parent
    }
}
