import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../config"

WlSessionLockSurface {
    id: surface
    property var context: null
    color: Globals.lockBgColor

    property string timeText: ""
    property string dateText: ""

    function refreshTime() {
        const now = new Date();
        const hh = String(now.getHours()).padStart(2, "0");
        const mm = String(now.getMinutes()).padStart(2, "0");
        timeText = hh + ":" + mm;
        const days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        const months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
        dateText = days[now.getDay()] + ", " + now.getDate() + " " + months[now.getMonth()];
    }

    Component.onCompleted: refreshTime()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: surface.refreshTime()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: input.forceActiveFocus()
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Globals.lockSpacing

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: surface.timeText
            color: Globals.lockTextColor
            font.family: Globals.widgetFontFamily
            font.pixelSize: Globals.lockClockSize
            font.bold: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: surface.dateText
            color: Globals.lockSubtextColor
            font.family: Globals.widgetFontFamily
            font.pixelSize: Globals.lockDateSize
        }

        Item { Layout.preferredHeight: Globals.lockSpacing }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: Globals.lockFieldWidth
            implicitHeight: Globals.lockFieldHeight
            radius: Globals.lockFieldRadius
            color: Globals.lockFieldBgColor
            border.color: Globals.lockFieldBorderColor
            border.width: 1

            TextInput {
                id: input
                anchors.fill: parent
                anchors.leftMargin: Globals.lockFieldPadding
                anchors.rightMargin: Globals.lockFieldPadding
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                color: Globals.lockFieldTextColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.lockFieldFontSize
                echoMode: TextInput.Password
                passwordCharacter: "•"
                selectionColor: Globals.lockFieldBorderColor
                selectedTextColor: Globals.lockFieldTextColor
                focus: true
                clip: true
                enabled: !(surface.context ? surface.context.isAuthenticating : false)

                onAccepted: {
                    const pwd = text;
                    text = "";
                    if (pwd.length > 0 && surface.context) {
                        surface.context.tryUnlock(pwd);
                    }
                }

                Component.onCompleted: forceActiveFocus()
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: surface.context ? surface.context.message : ""
            color: Globals.lockErrorColor
            font.family: Globals.widgetFontFamily
            font.pixelSize: Globals.lockDateSize
            visible: text.length > 0
        }
    }
}
