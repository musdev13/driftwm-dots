import Quickshell
import QtQuick
import "../config"
import "../widgets"
import "../widgets/clock"
import "../widgets/cpu"
import "../widgets/ram"
import "../widgets/battery"
import "../widgets/audio"
import "../widgets/divider"
import "../widgets/media"
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

            GroupWidget {
                anchors.verticalCenter: parent.verticalCenter
                CpuWidget {}
                RamWidget {}
            }
        }

        ClockWidget {
            id: clock
            anchors.centerIn: parent
        }

        Row {
            anchors.left: clock.right
            anchors.leftMargin: Globals.panelRowSpacing
            anchors.verticalCenter: parent.verticalCenter
            spacing: Globals.panelRowSpacing

            DividerWidget { anchors.verticalCenter: parent.verticalCenter }
            
            MediaWidget {
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: Globals.barPadding
            anchors.verticalCenter: parent.verticalCenter
            spacing: Globals.panelRowSpacing

            GroupWidget {
                anchors.verticalCenter: parent.verticalCenter
                VolumeWidget {}
                MicWidget {}
            }

            DividerWidget { anchors.verticalCenter: parent.verticalCenter }

            BatteryWidget { anchors.verticalCenter: parent.verticalCenter }
        }
    }

    NotificationPopup {
        panelWindow: barWindow
        panelHeight: 48
    }
}
