pragma Singleton
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property bool active: !Network.enabled
        && (!Bluetooth.available || !Bluetooth.enabled)

    readonly property string icon: "󰀝"
    readonly property string label: active ? "On" : "Off"

    function toggle() {
        const want = !active;
        Networking.wifiEnabled = !want;
        if (Bluetooth.adapter)
            Bluetooth.adapter.enabled = !want;
    }
}
