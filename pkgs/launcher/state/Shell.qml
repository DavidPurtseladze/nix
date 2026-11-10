pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool open: Quickshell.env("LAUNCHER_OPEN") === "1"
    property string initialText: Quickshell.env("LAUNCHER_TEXT") ?? ""

    function openWith(text: string): void {
        initialText = text;
        open = true;
    }
}
