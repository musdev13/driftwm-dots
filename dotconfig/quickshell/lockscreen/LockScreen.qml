import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Scope {
    id: root

    LockContext {
        id: lockContext
    }

    WlSessionLock {
        id: sessionLock
        locked: false

        LockSurface {
            context: lockContext
        }
    }

    Connections {
        target: lockContext
        function onUnlocked() {
            sessionLock.locked = false;
            lockContext.reset();
        }
    }

    IpcHandler {
        target: "lock"

        function lock(): void {
            sessionLock.locked = true;
            lockContext.start();
        }

        function unlock(): void {
            sessionLock.locked = false;
            lockContext.reset();
        }

        function isLocked(): bool {
            return sessionLock.locked;
        }
    }
}
