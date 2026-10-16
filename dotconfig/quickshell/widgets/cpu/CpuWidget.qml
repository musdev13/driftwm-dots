import QtQuick
import "../../config" as Config
import "../../services" as Services

Text {
    text: "\uf2db " + Math.round(Services.SystemStats.cpuUsage * 100) + "%"
    color: Config.Globals.widgetTextColor
    font.family: Config.Globals.widgetFontFamily
    font.pixelSize: Config.Globals.widgetFontSize
}
