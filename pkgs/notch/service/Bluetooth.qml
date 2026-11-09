pragma Singleton
import Quickshell
import Quickshell.Bluetooth as Bluez

Singleton {
    id: root

    readonly property var adapter: Bluez.Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null

    readonly property bool enabled: adapter ? adapter.enabled : false
    readonly property bool discovering: adapter ? adapter.discovering : false

    readonly property var devices: adapter && adapter.devices
        ? adapter.devices.values
        : []

    readonly property int nearbyLimit: 5

    property bool showAll: false
    property bool scanning: false

    function named(d) {
        const n = String(d.name || "").trim();
        if (n === "")
            return false;
        const addr = String(d.address || "").toUpperCase();
        return addr === "" || n.toUpperCase().replace(/-/g, ":") !== addr;
    }

    function byName(a, b) {
        const x = String(a.name || "").toLowerCase();
        const y = String(b.name || "").toLowerCase();
        return x < y ? -1 : (x > y ? 1 : 0);
    }

    function pick(test) {
        const out = [];
        for (let i = 0; i < devices.length; i++) {
            const d = devices[i];
            if (d && test(d))
                out.push(d);
        }
        out.sort(root.byName);
        return out;
    }

    readonly property var connected: pick(d => d.connected)

    readonly property var paired: pick(d => !d.connected && (d.paired || d.bonded))

    readonly property var known: connected.concat(paired)

    readonly property var nearby: {
        const seen = {};
        const out = [];
        const all = pick(
            d => !d.connected && !d.paired && !d.bonded && root.named(d));
        for (let i = 0; i < all.length; i++) {
            const key = String(all[i].name).toLowerCase();
            if (seen[key])
                continue;
            seen[key] = true;
            out.push(all[i]);
        }
        return out;
    }

    readonly property var shown: showAll
        ? nearby
        : nearby.slice(0, nearbyLimit)

    readonly property int hidden: nearby.length - shown.length

    onScanningChanged: {
        if (!adapter)
            return;
        adapter.discovering = scanning;
        if (!scanning)
            showAll = false;
    }

    readonly property string label: {
        if (!available)
            return "No adapter";
        if (!enabled)
            return "Off";
        if (connected.length === 1)
            return connected[0].name;
        if (connected.length > 1)
            return connected.length + " devices";
        return "Not connected";
    }

    readonly property string icon: {
        if (!enabled)
            return "󰂲";
        return connected.length > 0 ? "󰂱" : "󰂯";
    }

    function toggle() {
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }
}
