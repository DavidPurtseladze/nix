import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../state"
import "../theme"
import "../service"
import "../molecules"

Column {
    id: tab

    spacing: 9

    Flow {
        id: tiles

        width: parent.width
        spacing: Theme.tileSpacing

        readonly property real unit: (width - 3 * Theme.tileSpacing) / 4
        readonly property real wide: unit * 2 + Theme.tileSpacing

        SettingTile {
            width: tiles.wide
            icon: Network.icon
            label: "Wi-Fi"
            value: Network.label
            on: Network.enabled
            enabled: Network.available && Network.hardwareEnabled
            expandable: Network.enabled

            onToggled: Network.toggle()
            onOpened: Shell.settingsPage = "wifi"
        }

        SettingTile {
            width: tiles.wide
            icon: Bluetooth.icon
            label: "Bluetooth"
            value: Bluetooth.label
            on: Bluetooth.enabled
            enabled: Bluetooth.available
            expandable: Bluetooth.enabled

            onToggled: Bluetooth.toggle()
            onOpened: Shell.settingsPage = "bluetooth"
        }

        SettingTile {
            width: tiles.wide
            switchable: false
            expandable: true
            icon: Sound.muted ? "󰖁" : "󰕾"
            label: "Sound"
            value: Sound.label !== "" ? Sound.label : "No output"
            on: !Sound.muted

            onOpened: Shell.settingsTab = "audio"
        }

        SettingTile {
            width: tiles.wide
            switchable: false
            icon: Power.icon
            label: Power.hasBattery ? Power.percent + "%" : "On AC"
            value: {
                if (!Power.hasBattery)
                    return "No battery";
                if (Power.timeLabel === "")
                    return Power.charging ? "Charging" : "Discharging";
                return (Power.charging ? "Full in " : "Left ") + Power.timeLabel;
            }
            on: Power.hasBattery && Power.percent <= 15
        }

        ToggleChip {
            width: tiles.unit
            icon: Caffeine.icon
            label: "Caffeine"
            on: Caffeine.active

            onToggled: Caffeine.toggle()
        }

        ToggleChip {
            width: tiles.unit
            icon: Sunset.icon
            label: "Night"
            on: Sunset.enabled

            onToggled: Sunset.toggle()
        }

        ToggleChip {
            width: tiles.unit
            icon: Notifications.dnd ? "󰂛" : "󰂚"
            label: "Silent"
            on: Notifications.dnd

            onToggled: Notifications.dnd = !Notifications.dnd
        }

        ToggleChip {
            width: tiles.unit
            icon: Sound.inputMuted ? "󰍭" : "󰍬"
            label: "Mic"
            enabled: Sound.source !== null
            on: Sound.source !== null && !Sound.inputMuted

            onToggled: Sound.toggleInputMute()
        }

        ToggleChip {
            width: tiles.unit
            icon: Airplane.icon
            label: "Airplane"
            on: Airplane.active

            onToggled: Airplane.toggle()
        }

        ToggleChip {
            width: tiles.unit
            momentary: true
            icon: Capture.icon
            label: "Capture"

            onToggled: {
                Shell.clear();
                Capture.region();
            }
        }
    }

    SliderRow {
        width: parent.width
        visible: Backlight.available
        icon: "󰃠"
        value: Backlight.percent / 100

        onHeldChanged: Backlight.holding = held
        onMoved: v => Backlight.set(v * 100)
    }

    SliderRow {
        width: parent.width
        icon: "󰖔"
        readoutWidth: 38
        readout: Sunset.enabled ? Sunset.temperature + "K" : "Off"
        value: (Sunset.dayTemperature - Sunset.temperature)
            / (Sunset.dayTemperature - Sunset.minTemperature)

        onMoved: v => Sunset.set(
            Sunset.dayTemperature
                - v * (Sunset.dayTemperature - Sunset.minTemperature))
    }

    Column {
        width: parent.width
        visible: Power.hasProfiles
        spacing: 6

        SettingRow {
            width: parent.width
            label: "Power profile"
            value: Power.degraded
                ? Power.profileLabel + " · throttled"
                : Power.profileLabel
            dim: Power.degraded
        }

        Segmented {
            width: parent.width
            current: Power.profile

            options: {
                const out = [
                    { text: "Saver",    icon: "󰾪", value: PowerProfile.PowerSaver },
                    { text: "Balanced", icon: "󰾅", value: PowerProfile.Balanced }
                ];
                if (PowerProfiles.hasPerformanceProfile)
                    out.push({ text: "Performance", icon: "󰓅", value: PowerProfile.Performance });
                return out;
            }

            onPicked: v => Power.setProfile(v)
        }
    }
}
