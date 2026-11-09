import QtQuick
import "../theme"

Rectangle {
    id: button

    property string text: ""
    property bool primary: false
    property bool enabled: true

    signal activated

    implicitHeight: 32
    radius: 10
    opacity: button.enabled ? 1 : 0.4

    color: {
        if (button.primary)
            return pointer.hovered && button.enabled
                ? Qt.lighter(Theme.accent, 1.1)
                : Theme.accent;
        return pointer.hovered && button.enabled
            ? Theme.surfaceHover
            : Theme.surface;
    }

    Behavior on color {
        ColorAnimation { duration: 110 }
    }

    HoverHandler {
        id: pointer
        enabled: button.enabled
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        enabled: button.enabled
        onTapped: button.activated()
    }

    Text {
        anchors.centerIn: parent

        text: button.text
        color: button.primary ? Theme.background : Theme.text
        font.family: Theme.font
        font.pixelSize: 12
        font.weight: Font.DemiBold
    }
}
