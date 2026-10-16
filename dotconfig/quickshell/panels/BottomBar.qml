import Quickshell
import QtQuick
import QtQuick.Layouts
import "../config"
import "../widgets/taskbar"
import "../widgets/divider"
import "../widgets/tray"

PanelWindow {
    id: panelWindow

    color: Globals.panelColor

    anchors {
        bottom: true
        left: true
        right: true
    }

    implicitHeight: 48

    RowLayout {
        anchors.centerIn: parent
        spacing: Globals.panelRowSpacing

        TaskbarWidget {
            Layout.alignment: Qt.AlignVCenter
        }

        DividerWidget {
            Layout.alignment: Qt.AlignVCenter
        }

        TrayWidget {
            Layout.alignment: Qt.AlignVCenter
            panelWindow: panelWindow
        }
    }
}
