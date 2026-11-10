import QtQuick
import Quickshell
import Quickshell.Io
import "state"
import "service"

ShellRoot {
    FontLoader {
        source: `file://${Quickshell.env("LAUNCHER_ICON_FONT")}`
    }

    Launcher {}

    Component.onCompleted: Qt.callLater(() => [Apps, Themes])

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            Shell.open = !Shell.open;
        }

        function open(): void {
            Shell.open = true;
        }

        function close(): void {
            Shell.open = false;
        }

        function clipboard(): void {
            Shell.openWith(`${Config.actionPrefix}clip `);
        }
    }
}
