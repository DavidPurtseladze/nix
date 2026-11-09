import QtQuick
import "../theme"

Rectangle {
    id: button

    signal activated

    width: 24
    height: 24
    radius: 12
    color: pointer.hovered ? Qt.rgba(1, 1, 1, 0.14) : "transparent"

    Behavior on color {
        ColorAnimation { duration: 110 }
    }

    Text {
        anchors.centerIn: parent
        text: "󰅁"
        color: pointer.hovered ? Theme.text : Theme.textDim
        font.family: Theme.font
        font.pixelSize: 13
    }

    HoverHandler {
        id: pointer
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: button.activated()
    }
}
