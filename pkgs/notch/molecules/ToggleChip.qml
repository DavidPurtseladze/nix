import QtQuick
import "../theme"
import "../atoms"

Rectangle {
    id: chip

    property string icon: ""
    property string label: ""
    property bool on: false
    property bool enabled: true
    property bool momentary: false

    signal toggled

    implicitHeight: Theme.tileHeight
    radius: 12
    color: pointer.hovered && chip.enabled ? Theme.surfaceHover : Theme.surface
    opacity: chip.enabled ? 1 : 0.4

    Behavior on color {
        ColorAnimation { duration: 110 }
    }

    HoverHandler {
        id: pointer
        cursorShape: chip.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    TapHandler {
        enabled: chip.enabled
        onTapped: chip.toggled()
    }

    Column {
        anchors.centerIn: parent
        spacing: 5

        IconBadge {
            anchors.horizontalCenter: parent.horizontalCenter
            icon: chip.icon
            on: chip.on && !chip.momentary
            diameter: 30
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            width: chip.width - 8
            horizontalAlignment: Text.AlignHCenter

            text: chip.label
            color: chip.on && !chip.momentary ? Theme.text : Theme.textDim
            font.family: Theme.font
            font.pixelSize: 9
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }
    }
}
