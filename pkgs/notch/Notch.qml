import QtQuick
import Quickshell
import Quickshell.Wayland
import "state"
import "theme"
import "layout"

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

    // The shape whose name matches global state. Its implicit size is the box.
    readonly property Item shape: {
        for (let i = 0; i < shapes.children.length; i++) {
            const c = shapes.children[i];
            if (c.name === Shell.notchState)
                return c;
        }
        return null;
    }

    mask: Region {
        item: box
    }

    Rectangle {
        id: box

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        color: Theme.background
        clip: true

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

        // Every shape lives here. Add one file, add one line.
        Item {
            id: shapes
            anchors.fill: parent

            Clock {
                anchors.fill: parent
                opacity: name === Shell.notchState ? 1 : 0
                visible: opacity > 0
            }

            Audio {
                anchors.fill: parent
                opacity: name === Shell.notchState ? 1 : 0
                visible: opacity > 0
            }
        }
    }
}
