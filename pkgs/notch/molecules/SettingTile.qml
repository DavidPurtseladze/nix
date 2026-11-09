import QtQuick
import "../theme"
import "../atoms"

Rectangle {
    id: tile

    property string icon: ""
    property string label: ""
    property string value: ""
    property bool on: false
    property bool enabled: true
    property bool expandable: false
    property bool switchable: true

    signal toggled
    signal opened

    implicitHeight: Theme.tileHeight
    radius: 12
    color: pointer.hovered && tile.enabled ? Theme.surfaceHover : Theme.surface
    opacity: tile.enabled ? 1 : 0.4

    Behavior on color {
        ColorAnimation { duration: 110 }
    }

    HoverHandler {
        id: pointer
        cursorShape: tile.expandable && tile.enabled
            ? Qt.PointingHandCursor
            : Qt.ArrowCursor
    }

    TapHandler {
        enabled: tile.expandable && tile.enabled
        onTapped: tile.opened()
    }

    IconBadge {
        id: badge

        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.verticalCenter: parent.verticalCenter

        icon: tile.icon
        on: tile.on
        diameter: 30
    }

    Toggle {
        id: knob

        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter

        visible: tile.switchable
        checked: tile.on
        onActivated: if (tile.enabled) tile.toggled()
    }

    Chevron {
        id: chevron

        anchors.right: tile.switchable ? knob.left : parent.right
        anchors.rightMargin: tile.switchable ? 8 : 13
        anchors.verticalCenter: parent.verticalCenter

        visible: tile.expandable
        lit: pointer.hovered
    }

    Column {
        anchors.left: badge.right
        anchors.leftMargin: 10
        anchors.right: chevron.visible ? chevron.left : (knob.visible ? knob.left : parent.right)
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1

        Text {
            width: parent.width
            text: tile.label
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 12
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: text !== ""
            text: tile.value
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 10
            elide: Text.ElideRight
        }
    }
}
