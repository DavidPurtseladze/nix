pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string unit: "hypridle.service"

    property bool active: false

    readonly property string icon: active ? "󰅶" : "󰒲"
    readonly property string label: active ? "Awake" : "Off"

    Component.onCompleted: refresh()

    function refresh() {
        query.running = true;
    }

    function toggle() {
        root.active = !root.active;
        Quickshell.execDetached(["caffeine", root.active ? "on" : "off"]);
        settle.restart();
    }

    Process {
        id: query

        command: ["systemctl", "--user", "is-active", root.unit]

        stdout: StdioCollector {
            onStreamFinished: root.active = String(text).trim() !== "active"
        }
    }

    Timer {
        id: settle

        interval: 700
        onTriggered: root.refresh()
    }
}
