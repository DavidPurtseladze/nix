import QtQuick
import QtQuick.Effects
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
    readonly property real targetHeight: win.shape
        ? win.shape.implicitHeight * Theme.scale
        : 0

    implicitHeight: Math.max(440 * Theme.scale, targetHeight + 40)
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

    // Only the focused output expands. Every other screen keeps the clock.
    readonly property bool focused: Hyprland.focusedMonitor
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

    Rectangle {
        id: shadowShape

        anchors.horizontalCenter: parent.horizontalCenter
        y: box.y
        width: box.width
        height: box.height
        color: Theme.background

        topLeftRadius: box.topLeftRadius
        topRightRadius: box.topRightRadius
        bottomLeftRadius: box.bottomLeftRadius
        bottomRightRadius: box.bottomRightRadius

        visible: false
    }

    MultiEffect {
        source: shadowShape
        anchors.fill: shadowShape
        z: -1

        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: Theme.shadow
        shadowOpacity: Theme.shadowOpacity
        shadowBlur: Theme.shadowBlur
        blurMax: Theme.shadowBlurMax
        shadowVerticalOffset: Theme.shadowOffset
    }

    ClippingRectangle {
        id: box

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        color: Theme.background

        width: win.shape ? win.shape.implicitWidth * Theme.scale : 0
        height: win.shape ? win.shape.implicitHeight * Theme.scale : 0

        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: win.shape ? win.shape.radius * Theme.scale : 0
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

            Keys.onEscapePressed: Shell.back()
        }

        // Every shape lives here. Add one file, add one line.
        Item {
            id: shapes

            width: box.width / Theme.scale
            height: box.height / Theme.scale
            transformOrigin: Item.TopLeft
            scale: Theme.scale

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


            Settings {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            WifiPage {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            BluetoothPage {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            OutputPage {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

            InputPage {
                anchors.fill: parent
                opacity: name === win.currentState ? 1 : 0
                visible: opacity > 0
            }

        }
    }
}
