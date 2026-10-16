import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../../config" as Config

Text {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property real pct: device && device.ready ? device.percentage : 0
    readonly property bool charging: device
        && (device.state === UPowerDeviceState.Charging
            || device.state === UPowerDeviceState.FullyCharged
            || device.state === UPowerDeviceState.PendingCharge)
    readonly property bool present: device && device.isLaptopBattery && device.ready

    visible: present

    text: {
        if (!present) return "";
        var icon;
        if (charging)
            icon = "\u{f0e7}";
        else if (pct <= 0.10)
            icon = "\u{f244}";
        else if (pct <= 0.35)
            icon = "\u{f243}";
        else if (pct <= 0.60)
            icon = "\u{f242}";
        else if (pct <= 0.85)
            icon = "\u{f241}";
        else
            icon = "\u{f240}";
        return Math.round(pct * 100) + "%" + " " + icon;
    }

    color: {
        if (!present) return Config.Globals.widgetTextColor;
        var p = pct * 100;
        if (p <= 10) return Config.Globals.batteryLowColor;
        if (p <= 20) return Config.Globals.batteryMediumColor;
        return Config.Globals.batteryHighColor;
    }

    font.family: Config.Globals.widgetFontFamily
    font.pixelSize: Config.Globals.widgetFontSize
}
