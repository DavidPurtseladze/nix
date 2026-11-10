pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property color background: "#000000"
    readonly property color text: "#ffffff"
    readonly property color textDim: "#8d9a9b"
    readonly property color accent: "#6fbfb8"

    readonly property color surface: Qt.rgba(1, 1, 1, 0.05)
    readonly property color surfaceHover: Qt.rgba(1, 1, 1, 0.09)
    readonly property color line: Qt.rgba(1, 1, 1, 0.08)
    readonly property color track: Qt.rgba(1, 1, 1, 0.2)

    readonly property real scale: 1.25

    readonly property color shadow: "#000000"
    readonly property real shadowOpacity: 0.22
    readonly property real shadowBlur: 1.0
    readonly property int shadowBlurMax: 72
    readonly property int shadowOffset: 2

    readonly property int panelWidth: 520
    readonly property int panelPad: 14
    readonly property int tileSpacing: 7
    readonly property int tileHeight: 60

    readonly property string font: "FiraCode Nerd Font"
    readonly property string fontMono: "FiraCode Nerd Font Mono"
}
