import QtQuick
import "../theme"

Item {
    id: button

    property string glyph: ""
    property bool active: true
    property int size: 14

    signal activated

    width: 28

    HoverHandler {
        id: pointer
        enabled: button.active
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        enabled: button.active
        onTapped: button.activated()
    }

    Text {
        anchors.centerIn: parent

        text: button.glyph
        color: !button.active
            ? Theme.track
            : (pointer.hovered ? Theme.accent : Theme.text)
        font.family: Theme.font
        font.pixelSize: button.size

        Behavior on color {
            ColorAnimation { duration: 110 }
        }
    }
}
