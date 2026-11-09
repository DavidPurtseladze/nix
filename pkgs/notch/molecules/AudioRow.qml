import QtQuick
import "../theme"

Item {
    id: row

    property var node: null
    property string icon: ""
    property string title: ""
    property bool active: false

    signal picked

    implicitHeight: 38

    HoverHandler {
        id: pointer
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: row.picked()
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 9
        color: row.active
            ? Qt.rgba(1, 1, 1, 0.07)
            : (pointer.hovered ? Theme.surface : "transparent")

        Behavior on color {
            ColorAnimation { duration: 110 }
        }
    }

    Text {
        id: glyph

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 18
        horizontalAlignment: Text.AlignHCenter

        text: row.icon
        color: row.active ? Theme.accent : Theme.textDim
        font.family: Theme.font
        font.pixelSize: 14
    }

    Text {
        anchors.left: glyph.right
        anchors.leftMargin: 10
        anchors.right: check.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        text: row.title
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 12
        font.weight: row.active ? Font.DemiBold : Font.Normal
        elide: Text.ElideRight
    }

    Text {
        id: check

        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter

        visible: row.active
        text: "󰄬"
        color: Theme.accent
        font.family: Theme.font
        font.pixelSize: 12
    }
}
