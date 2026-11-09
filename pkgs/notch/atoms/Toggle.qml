import QtQuick
import "../theme"

Rectangle {
    id: toggle

    property bool checked: false

    signal activated

    width: 34
    height: 18
    radius: 9
    color: checked
        ? Theme.accent
        : (pointer.hovered ? Theme.surfaceHover : Theme.track)

    Behavior on color {
        ColorAnimation { duration: 140 }
    }

    Rectangle {
        y: 3
        x: toggle.checked ? toggle.width - width - 3 : 3
        width: 12
        height: 12
        radius: 6
        color: toggle.checked ? Theme.background : Theme.text

        Behavior on x {
            NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
        }
    }

    HoverHandler {
        id: pointer
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: toggle.activated()
    }
}
