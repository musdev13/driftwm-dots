import Quickshell
import QtQuick
import "../config"
import "../widgets/clock"
import "../widgets/cpu"
import "../widgets/ram"
import "../widgets/battery"
import "NotificationPopup.qml"

Scope {
    PanelWindow {
        id: barWindow

        color: Globals.panelColor

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 48

        Row {
            anchors.left: parent.left
            anchors.leftMargin: Globals.barPadding
            anchors.verticalCenter: parent.verticalCenter
            spacing: Globals.panelRowSpacing

            CpuWidget {}
            RamWidget {}
        }

        ClockWidget {
            anchors.centerIn: parent
        }

        BatteryWidget {
            anchors.right: parent.right
            anchors.rightMargin: Globals.barPadding
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    NotificationPopup {
        panelWindow: barWindow
        panelHeight: 48
    }
}
