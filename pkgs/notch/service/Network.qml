pragma Singleton
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property bool available: Networking.backend !== NetworkBackendType.None

    readonly property bool enabled: Networking.wifiEnabled
    readonly property bool hardwareEnabled: Networking.wifiHardwareEnabled
    readonly property bool online: Networking.connectivity === NetworkConnectivity.Full

    readonly property var device: {
        const list = Networking.devices ? Networking.devices.values : [];
        for (let i = 0; i < list.length; i++) {
            if (list[i].type === DeviceType.Wifi)
                return list[i];
        }
        return null;
    }

    readonly property var networks: device && device.networks
        ? device.networks.values
        : []

    readonly property var active: {
        for (let i = 0; i < networks.length; i++) {
            if (networks[i].connected)
                return networks[i];
        }
        return null;
    }

    readonly property string ssid: active ? active.name : ""
    readonly property int signal: active
        ? Math.round(active.signalStrength * 100)
        : 0
    readonly property bool busy: device
        && device.state === ConnectionState.Connecting

    readonly property var visible: {
        const seen = {};
        const out = [];
        const sorted = networks.slice().sort(
            (a, b) => b.signalStrength - a.signalStrength);

        for (let i = 0; i < sorted.length; i++) {
            const n = sorted[i];
            if (!n.name || seen[n.name])
                continue;
            seen[n.name] = true;
            out.push(n);
        }
        return out;
    }

    property bool scanning: false

    onScanningChanged: if (device) device.scannerEnabled = scanning

    readonly property string label: {
        if (!available)
            return "No backend";
        if (!enabled)
            return "Off";
        if (busy)
            return "Connecting…";
        return ssid !== "" ? ssid : "Not connected";
    }

    readonly property string icon: {
        if (!enabled)
            return "󰤭";
        if (ssid === "")
            return "󰤯";
        if (signal >= 75)
            return "󰤨";
        if (signal >= 50)
            return "󰤥";
        if (signal >= 25)
            return "󰤢";
        return "󰤟";
    }

    function toggle() {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }
}
