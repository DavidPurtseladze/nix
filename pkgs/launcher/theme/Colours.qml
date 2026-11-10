pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property QtObject palette: QtObject {
        readonly property color m3surface: "#000000"
        readonly property color m3surfaceContainer: "#141818"
        readonly property color m3onSurface: "#ffffff"
        readonly property color m3onSurfaceVariant: "#8d9a9b"
        readonly property color m3outline: "#6b7778"
        readonly property color m3primary: "#6fbfb8"
        readonly property color m3onPrimary: "#00201e"
        readonly property color m3tertiary: "#9ec9e2"
        readonly property color m3onTertiary: "#00202f"
        readonly property color m3error: "#ffb4ab"
    }
}
