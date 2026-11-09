pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int percent: 0
    property bool available: false

    property bool holding: false

    function set(value) {
        const v = Math.max(1, Math.min(100, Math.round(value)));
        if (v === percent)
            return;
        percent = v;
        write.restart();
    }

    function refresh() {
        if (!holding)
            read.running = true;
    }

    Timer {
        id: write

        interval: 40
        onTriggered: Quickshell.execDetached(
            ["brightnessctl", "-q", "set", root.percent + "%"])
    }

    Process {
        id: read

        running: true
        command: ["brightnessctl", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(",");
                if (parts.length < 4)
                    return;
                root.available = true;
                if (!root.holding)
                    root.percent = parseInt(parts[3]);
            }
        }
    }

    Timer {
        interval: 2000
        running: root.available
        repeat: true
        onTriggered: root.refresh()
    }
}
