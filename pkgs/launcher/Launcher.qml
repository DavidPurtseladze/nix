pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "state"
import "theme"
import "atoms"
import "organisms"

PanelWindow {
    id: win

    readonly property bool shouldBeActive: Shell.open
    property real offsetScale: shouldBeActive ? 0 : 1
    readonly property int r: Tokens.rounding.extraLarge

    function focusedScreen(): ShellScreen {
        const name = Hyprland.focusedMonitor?.name;
        return Quickshell.screens.find(s => s.name === name) ?? Quickshell.screens[0];
    }

    screen: focusedScreen()
    visible: shouldBeActive || offsetScale < 1
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "launcher"
    WlrLayershell.keyboardFocus: shouldBeActive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    onShouldBeActiveChanged: {
        if (shouldBeActive) {
            screen = focusedScreen();
            panel.implicitHeight = Qt.binding(() => content.implicitHeight);
        } else {
            panel.implicitHeight = panel.implicitHeight;
        }
    }

    Behavior on offsetScale {
        Anim {
            type: Anim.Emphasized
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: win.shouldBeActive
        onClicked: Shell.open = false
    }

    Item {
        id: panel

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: (-implicitHeight - 5) * win.offsetScale

        implicitWidth: content.implicitWidth || 630
        implicitHeight: content.implicitHeight
        opacity: 1 - win.offsetScale

        MouseArea {
            anchors.fill: parent
        }

        Rectangle {
            anchors.fill: parent
            color: Colours.palette.m3surface
            topLeftRadius: Math.min(win.r, height / 2)
            topRightRadius: Math.min(win.r, height / 2)
        }

        Loader {
            id: content

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            active: win.visible

            sourceComponent: Content {
                maxHeight: (win.screen?.height ?? 1080) - Tokens.padding.extraLarge * 2
            }
        }
    }
}
