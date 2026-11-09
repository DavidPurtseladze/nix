import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "state"
import "service"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Notch {
            required property var modelData
            screen: modelData
        }
    }

    // Outside control — keybinds and scripts: `ipc call notch show notifications`.
    IpcHandler {
        target: "notch"

        function show(name: string): void {
            if (name === "notifications")
                Shell.open("alerts");
            else if (name === "notification")
                Shell.wantsNotification = true;
            else if (name === "settings")
                Shell.settingsOpen = true;
            else if (name === "sound")
                Shell.open("audio");
            else if (name === "wifi" || name === "bluetooth"
                    || name === "output" || name === "input") {
                Shell.settingsOpen = true;
                Shell.settingsPage = name;
            }
        }

        function toggle(name: string): void {
            if (name === "settings")
                Shell.settingsOpen = !Shell.settingsOpen;
        }

        function settings(): void {
            Shell.settingsOpen = !Shell.settingsOpen;
        }

        function wifi(): void {
            Shell.settingsOpen = true;
            Shell.settingsPage = "wifi";
        }

        function bluetooth(): void {
            Shell.settingsOpen = true;
            Shell.settingsPage = "bluetooth";
        }

        function join(name: string): void {
            Shell.settingsOpen = true;
            Shell.settingsPage = "wifi";
            const list = Network.visible;
            for (let i = 0; i < list.length; i++) {
                if (list[i].name === name) {
                    Shell.joinTarget = list[i];
                    return;
                }
            }
        }

        function sound(): void {
            Shell.open("audio");
        }

        function notifications(): void {
            Shell.open("alerts");
        }

        function output(): void {
            Shell.settingsOpen = true;
            Shell.settingsPage = "output";
        }

        function input(): void {
            Shell.settingsOpen = true;
            Shell.settingsPage = "input";
        }

        function nightlight(): void {
            Sunset.toggle();
        }

        function caffeine(): void {
            Caffeine.toggle();
        }

        function back(): void {
            Shell.back();
        }

        function close(): void {
            Shell.clear();
        }

        function state(): string {
            return Shell.notchState;
        }
    }

    Binding {
        target: Network
        property: "scanning"
        value: Shell.notchState === "settings.wifi"
    }

    Binding {
        target: Bluetooth
        property: "scanning"
        value: Shell.notchState === "settings.bluetooth"
    }

    // hijack the escape button 
    readonly property bool showing: Shell.wantsNotification
        || Shell.settingsOpen

    // Evaluated at call time: a Process whose command is a binding on
    // `showing` races the signal and runs the previous state's command.
    onShowingChanged: Quickshell.execDetached(["hyprctl", "eval", root.showing
        ? 'hl.bind("Escape", hl.dsp.global("notch:dismiss"))'
        : 'hl.unbind("Escape")'])

    GlobalShortcut {
        appid: "notch"
        name: "dismiss"
        onPressed: Shell.back()
    }

    GlobalShortcut {
        appid: "notch"
        name: "settings"
        onPressed: Shell.settingsOpen = !Shell.settingsOpen
    }

    // Never leave Escape hijacked if the shell goes away.
    Component.onDestruction: Quickshell.execDetached(
        ["hyprctl", "eval", 'hl.unbind("Escape")'])
}
