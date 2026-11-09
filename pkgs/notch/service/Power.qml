pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery && battery.isPresent

    readonly property int percent: hasBattery
        ? Math.round(battery.percentage * 100)
        : 0
    readonly property bool charging: hasBattery
        && (battery.state === UPowerDeviceState.Charging
            || battery.state === UPowerDeviceState.FullyCharged)
    readonly property bool onBattery: UPower.onBattery

    readonly property int remaining: !hasBattery
        ? 0
        : (charging ? battery.timeToFull : battery.timeToEmpty)

    readonly property string timeLabel: {
        if (!hasBattery || remaining <= 0)
            return "";
        const h = Math.floor(remaining / 3600);
        const m = Math.floor((remaining % 3600) / 60);
        return h > 0 ? h + "h " + m + "m" : m + "m";
    }

    readonly property string icon: {
        if (!hasBattery)
            return "󰚥";
        if (charging)
            return "󰂄";
        if (percent >= 90) return "󰁹";
        if (percent >= 70) return "󰂀";
        if (percent >= 50) return "󰁾";
        if (percent >= 30) return "󰁼";
        if (percent >= 10) return "󰁺";
        return "󰂎";
    }

    property bool hasProfiles: false

    readonly property var order: PowerProfiles.hasPerformanceProfile
        ? [PowerProfile.PowerSaver, PowerProfile.Balanced, PowerProfile.Performance]
        : [PowerProfile.PowerSaver, PowerProfile.Balanced]

    readonly property int profile: PowerProfiles.profile

    readonly property string profileLabel: {
        switch (profile) {
        case PowerProfile.PowerSaver: return "Power saver";
        case PowerProfile.Performance: return "Performance";
        default: return "Balanced";
        }
    }

    readonly property string profileIcon: {
        switch (profile) {
        case PowerProfile.PowerSaver: return "󰾪";
        case PowerProfile.Performance: return "󰓅";
        default: return "󰾅";
        }
    }

    readonly property bool degraded:
        PowerProfiles.degradationReason !== PerformanceDegradationReason.None

    function setProfile(p) {
        PowerProfiles.profile = p;
    }

    function cycleProfile() {
        const i = order.indexOf(profile);
        setProfile(order[(i + 1) % order.length]);
    }

    Process {
        id: ppd

        running: true
        command: ["systemctl", "is-active", "--quiet", "power-profiles-daemon"]
        onExited: code => root.hasProfiles = code === 0
    }

    function lock()    { Quickshell.execDetached(["qylock-lock"]); }
    function suspend() { Quickshell.execDetached(["systemctl", "suspend"]); }
    function reboot()  { Quickshell.execDetached(["systemctl", "reboot"]); }
    function off()     { Quickshell.execDetached(["systemctl", "poweroff"]); }
}
