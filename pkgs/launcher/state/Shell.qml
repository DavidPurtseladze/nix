pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool open: Quickshell.env("LAUNCHER_OPEN") === "1"
}
