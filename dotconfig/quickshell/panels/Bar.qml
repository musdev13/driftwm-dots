import Quickshell
import QtQuick
import "../config"
import "../widgets/clock"

PanelWindow {
    color: Globals.panelColor

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 48

    ClockWidget {
        anchors.centerIn: parent
    }
}