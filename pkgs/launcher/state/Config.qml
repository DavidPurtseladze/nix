pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property int maxShown: 7
    readonly property string specialPrefix: "@"
    readonly property string actionPrefix: ">"
    readonly property bool enableDangerousActions: true
    readonly property bool vimKeybinds: false
    readonly property list<string> favouriteApps: []
    readonly property list<string> hiddenApps: []
    readonly property bool useFuzzyApps: false
    readonly property bool useFuzzyActions: false
    readonly property bool useFuzzyThemes: true
    readonly property list<string> themePrefixes: ["theme", "color", "colors"]
    readonly property list<string> terminal: ["kitty"]

    readonly property var actions: [
        {
            name: "Calculator",
            icon: "calculate",
            description: "Do simple maths equations (powered by Qalc)",
            command: ["autocomplete", "calc"]
        },
        {
            name: "Theme",
            icon: "palette",
            description: "Change the colour scheme",
            command: ["autocomplete", "theme"]
        },
        {
            name: "Lock",
            icon: "lock",
            description: "Lock the current session",
            command: ["flock", "-n", "/tmp/qylock.lock", "qylock-lock"]
        },
        {
            name: "Sleep",
            icon: "bedtime",
            description: "Suspend the system",
            command: ["systemctl", "suspend"]
        },
        {
            name: "Hibernate",
            icon: "downloading",
            description: "Save the session to disk and power off",
            command: ["systemctl", "hibernate"]
        },
        {
            name: "Logout",
            icon: "exit_to_app",
            description: "Exit Hyprland",
            command: ["hyprctl", "eval", "hl.dispatch(hl.dsp.exit())"],
            dangerous: true
        },
        {
            name: "Reboot",
            icon: "cached",
            description: "Reboot the system",
            command: ["systemctl", "reboot"],
            dangerous: true
        },
        {
            name: "Shutdown",
            icon: "power_settings_new",
            description: "Shutdown the system",
            command: ["systemctl", "poweroff"],
            dangerous: true
        }
    ]
}
