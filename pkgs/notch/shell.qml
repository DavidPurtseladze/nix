import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "state"

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
                Shell.listOpen = true;
            else if (name === "notification")
                Shell.wantsNotification = true;
        }

        function close(): void {
            Shell.clear();
        }

        function state(): string {
            return Shell.notchState;
        }
    }

    // hijack the escape button 
    readonly property bool showing: Shell.wantsNotification || Shell.listOpen

    onShowingChanged: escBind.running = true

    Process {
        id: escBind

        command: ["hyprctl", "eval", root.showing
            ? 'hl.bind("Escape", hl.dsp.global("notch:dismiss"))'
            : 'hl.unbind("Escape")']
    }

    GlobalShortcut {
        appid: "notch"
        name: "dismiss"
        onPressed: Shell.clear()
    }

    // Never leave Escape hijacked if the shell goes away.
    Component.onDestruction: Quickshell.execDetached(
        ["hyprctl", "eval", 'hl.unbind("Escape")'])
}
