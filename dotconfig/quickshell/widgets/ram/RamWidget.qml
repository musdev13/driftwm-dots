import QtQuick
import "../../config" as Config
import "../../services" as Services

Text {
    text: "\u{f1c0} " + Math.round(Services.SystemStats.ramUsage * 100) + "%"
    color: Config.Globals.widgetTextColor
    font.family: Config.Globals.widgetFontFamily
    font.pixelSize: Config.Globals.widgetFontSize
}
