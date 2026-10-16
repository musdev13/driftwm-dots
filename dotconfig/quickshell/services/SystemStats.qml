pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real cpuUsage: 0
    property real ramUsage: 0

    property var _prevCpu: null
    property int _memTotal: 0
    property int _memAvailable: 0

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                if (!line.startsWith("cpu "))
                    return;

                var parts = line.trim().split(/\s+/).slice(1).map(Number);
                var idle = parts[3] + (parts[4] || 0);
                var total = parts.reduce(function(a, b) { return a + b; }, 0);

                if (root._prevCpu) {
                    var dTotal = total - root._prevCpu.total;
                    var dIdle = idle - root._prevCpu.idle;
                    if (dTotal > 0)
                        root.cpuUsage = Math.max(0, Math.min(1, 1 - dIdle / dTotal));
                }

                root._prevCpu = { total: total, idle: idle };
            }
        }
    }

    Process {
        id: ramProc
        command: ["cat", "/proc/meminfo"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                var m;
                if ((m = line.match(/^MemTotal:\s+(\d+)/)))
                    root._memTotal = parseInt(m[1]);
                else if ((m = line.match(/^MemAvailable:\s+(\d+)/)))
                    root._memAvailable = parseInt(m[1]);
            }
        }

        onExited: {
            if (root._memTotal > 0)
                root.ramUsage = Math.max(0, Math.min(1,
                    (root._memTotal - root._memAvailable) / root._memTotal));
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            ramProc.running = true;
        }
    }
}
