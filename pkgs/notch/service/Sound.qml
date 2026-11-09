pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    // node.name -> true when its device route reports available: "no"
    property var blocked: ({})
    property bool watching: false

    function usable(node) {
        return node ? !blocked[node.name] : false;
    }

    function devices(wantSink, wantUsable) {
        const all = Pipewire.nodes ? Pipewire.nodes.values : [];
        const out = [];
        for (let i = 0; i < all.length; i++) {
            const n = all[i];
            if (!n || n.isStream || !n.audio)
                continue;
            if (n.isSink !== wantSink)
                continue;
            if (usable(n) !== wantUsable)
                continue;
            out.push(n);
        }
        out.sort((a, b) => {
            const x = root.title(a).toLowerCase();
            const y = root.title(b).toLowerCase();
            return x < y ? -1 : (x > y ? 1 : 0);
        });
        return out;
    }

    readonly property var sinks: devices(true, true)
    readonly property var sources: devices(false, true)

    readonly property var deadSinks: devices(true, false)
    readonly property var deadSources: devices(false, false)

    function title(node) {
        if (!node)
            return "";
        return node.nickname || node.description || node.name || "";
    }

    function glyph(node, isSink) {
        const name = ((node ? node.name : "") + " " + title(node)).toLowerCase();
        if (!isSink)
            return name.indexOf("bluez") >= 0 ? "󰋎" : "󰍬";
        if (name.indexOf("bluez") >= 0)
            return "󰋋";
        if (name.indexOf("hdmi") >= 0 || name.indexOf("displayport") >= 0)
            return "󰡁";
        if (name.indexOf("headphone") >= 0 || name.indexOf("headset") >= 0)
            return "󰋋";
        if (name.indexOf("usb") >= 0)
            return "󰓃";
        return "󰓃";
    }

    readonly property real volume: sink && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink && sink.audio ? sink.audio.muted : false

    readonly property real inputVolume: source && source.audio ? source.audio.volume : 0
    readonly property bool inputMuted: source && source.audio ? source.audio.muted : false

    readonly property string label: title(sink)

    // Writing the preferred node makes WirePlumber persist it as
    // default.configured.audio.* — the choice survives a reboot.
    function setSink(node) {
        if (!usable(node))
            return;
        Pipewire.preferredDefaultAudioSink = node;
    }

    function setSource(node) {
        if (!usable(node))
            return;
        Pipewire.preferredDefaultAudioSource = node;
    }

    function setVolume(v) {
        if (sink && sink.audio)
            sink.audio.volume = v;
    }

    function setInputVolume(v) {
        if (source && source.audio)
            source.audio.volume = v;
    }

    function toggleMute() {
        if (sink && sink.audio)
            sink.audio.muted = !sink.audio.muted;
    }

    function toggleInputMute() {
        if (source && source.audio)
            source.audio.muted = !source.audio.muted;
    }

    PwObjectTracker {
        objects: root.sinks.concat(root.sources)
    }

    function refresh() {
        if (!dump.running)
            dump.running = true;
    }

    Component.onCompleted: refresh()

    Process {
        id: dump

        command: ["pw-dump"]

        stdout: StdioCollector {
            onStreamFinished: {
                let data;
                try {
                    data = JSON.parse(String(text));
                } catch (e) {
                    return;
                }
                const routes = {};
                for (let i = 0; i < data.length; i++) {
                    const o = data[i];
                    if (o.type !== "PipeWire:Interface:Device")
                        continue;
                    const list = ((o.info && o.info.params) || {}).EnumRoute || [];
                    for (let j = 0; j < list.length; j++) {
                        const r = list[j];
                        const devs = r.devices || [];
                        for (let k = 0; k < devs.length; k++)
                            routes[o.id + ":" + devs[k]] = r.available;
                    }
                }

                const out = {};
                for (let i = 0; i < data.length; i++) {
                    const o = data[i];
                    if (o.type !== "PipeWire:Interface:Node")
                        continue;
                    const p = (o.info && o.info.props) || {};
                    const name = p["node.name"];
                    if (name === undefined)
                        continue;
                    const key = p["device.id"] + ":" + p["card.profile.device"];
                    if (routes[key] === "no")
                        out[name] = true;
                }
                root.blocked = out;
            }
        }
    }

    Timer {
        interval: 3000
        running: root.watching
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
