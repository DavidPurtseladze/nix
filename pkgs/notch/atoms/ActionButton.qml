import QtQuick
import "../theme"

// An answer to a notification that asked a question.
Rectangle {
    id: button

    property alias text: label.text
    property bool primary: false

    signal activated

    height: 30
    radius: 9
    color: primary
        ? Theme.text
        : (pointer.hovered ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(1, 1, 1, 0.09))
    opacity: primary && pointer.hovered ? 0.88 : 1

    Behavior on color {
        ColorAnimation { duration: 110 }
    }

    Text {
        id: label
        anchors.centerIn: parent
        width: parent.width - 16
        horizontalAlignment: Text.AlignHCenter
        color: button.primary ? Theme.background : Theme.text
        font.family: Theme.font
        font.pixelSize: 12
        font.weight: Font.DemiBold
        elide: Text.ElideRight
    }

    HoverHandler {
        id: pointer
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: button.activated()
    }
}
