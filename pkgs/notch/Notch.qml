import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import "state"
import "theme"
import "organisms"

PanelWindow {
    id: win

    color: "transparent"
    implicitHeight: 440
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notch"

    // Only shapes that ask for it can take the keyboard
    WlrLayershell.keyboardFocus: shape && shape.focusable
        ? WlrKeyboardFocus.OnDemand
        : WlrKeyboardFocus.None

    // Only the focused output expands. Every other screen keeps the clock
        && Hyprland.focusedMonitor.name === win.screen.name

    readonly property string currentState: focused ? Shell.notchState : "default"

    // The shape whose name matches state. Its implicit size is the box.
    readonly property Item shape: {
        for (let i = 0; i < shapes.children.length; i++) {
            const c = shapes.children[i];
            if (c.name === win.currentState)
                return c;
        }
        return null;
    }

    mask: Region {
        item: box
    }

    ClippingRectangle {
        id: box

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        color: Theme.background

        width: win.shape ? win.shape.implicitWidth : 0
        height: win.shape ? win.shape.implicitHeight : 0

        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: win.shape ? win.shape.radius : 0
        bottomRightRadius: bottomLeftRadius

        Behavior on width {
            NumberAnimation { duration: 340; easing.type: Easing.OutCubic }
        }
        Behavior on height {
            NumberAnimation { duration: 340; easing.type: Easing.OutCubic }
        }

        Item {
            anchors.fill: parent
            focus: true

            Keys.onEscapePressed: Shell.clear()
        }

        // Every shape lives here. Add one file, add one line.
        Item {
            id: shapes
            anchors.fill: parent

            Clock {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            Audio {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            Notification {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            NotificationList {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }
        }
    }
}
