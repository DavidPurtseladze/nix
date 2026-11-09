pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property int dayTemperature: 6000
    readonly property int minTemperature: 2500
    readonly property int warmTemperature: 4000

    property int temperature: dayTemperature

    readonly property bool enabled: temperature < dayTemperature
    readonly property string icon: enabled ? "󰖔" : "󰖙"
    readonly property string label: enabled ? temperature + "K" : "Off"

    Component.onCompleted: refresh()

    function refresh() {
        query.running = true;
    }

    function set(kelvin) {
        const t = Math.max(minTemperature, Math.min(dayTemperature, Math.round(kelvin)));
        root.temperature = t;
        if (throttle.running)
            pending = true;
        else
            apply();
    }

    property bool pending: false

    function apply() {
        Quickshell.execDetached(
            ["hyprctl", "hyprsunset", "temperature", String(root.temperature)]);
        throttle.restart();
    }

    Timer {
        id: throttle

        interval: 90
        onTriggered: if (root.pending) {
            root.pending = false;
            root.apply();
        }
    }

    function toggle() {
        set(enabled ? dayTemperature : warmTemperature);
    }

    Process {
        id: query

        command: ["hyprctl", "hyprsunset", "temperature"]

        stdout: StdioCollector {
            onStreamFinished: {
                const t = parseInt(String(text).trim(), 10);
                if (!isNaN(t) && t > 0)
                    root.temperature = t;
            }
        }
    }
}
