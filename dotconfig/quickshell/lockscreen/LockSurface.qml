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

    Component.onCompleted: {
        refreshTime();
        fadeIn.start();
    }

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

    Connections {
        target: surface.context
        function onFailed() {
            shakeAnim.start();
            input.forceActiveFocus();
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.centerIn: parent
        spacing: Globals.lockSpacing
        opacity: 0

        NumberAnimation {
            id: fadeIn
            target: mainLayout
            property: "opacity"
            to: 1
            duration: 500
            easing.type: Easing.OutCubic
        }

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

        Item { Layout.preferredHeight: Globals.lockSpacing / 2 }

        Item {
            id: inputContainer
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: Globals.lockFieldWidth
            implicitHeight: Globals.lockFieldHeight

            transform: Translate { id: shakeTranslate }

            SequentialAnimation {
                id: shakeAnim
                NumberAnimation { target: shakeTranslate; property: "x"; to: -12; duration: 50 }
                NumberAnimation { target: shakeTranslate; property: "x"; to: 12; duration: 50 }
                NumberAnimation { target: shakeTranslate; property: "x"; to: -10; duration: 50 }
                NumberAnimation { target: shakeTranslate; property: "x"; to: 10; duration: 50 }
                NumberAnimation { target: shakeTranslate; property: "x"; to: -5; duration: 50 }
                NumberAnimation { target: shakeTranslate; property: "x"; to: 0; duration: 50 }
            }

            TextInput {
                id: input
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignHCenter
                color: Globals.lockFieldTextColor
                font.family: Globals.widgetFontFamily
                font.pixelSize: Globals.lockFieldFontSize
                echoMode: TextInput.Password
                passwordCharacter: "•"
                selectionColor: Globals.lockFieldLineActiveColor
                selectedTextColor: Globals.lockFieldTextColor
                focus: true
                clip: true
                enabled: !(surface.context ? surface.context.isAuthenticating : false)
                topPadding: 0
                bottomPadding: 8

                onAccepted: {
                    const pwd = text;
                    text = "";
                    if (pwd.length > 0 && surface.context) {
                        surface.context.tryUnlock(pwd);
                    }
                }

                Component.onCompleted: forceActiveFocus()
            }

            Rectangle {
                id: underline
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: input.activeFocus ? Globals.lockFieldLineActiveColor : Globals.lockFieldLineColor
                
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
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
