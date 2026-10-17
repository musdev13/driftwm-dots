import QtQuick
import "../../config" as Config
import "../../services" as Services

Text {
    text: Services.Time.time
    color: Config.Globals.clockColor
    font.bold: true
    font.pixelSize: Config.Globals.clockSize
}