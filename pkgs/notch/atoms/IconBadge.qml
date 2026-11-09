import QtQuick
import "../theme"

Rectangle {
    id: badge

    property string icon: ""
    property bool on: false
    property int diameter: 32

    width: diameter
    height: diameter
    radius: diameter / 2

    color: on ? Theme.accent : Qt.rgba(1, 1, 1, 0.10)

    Behavior on color {
        ColorAnimation { duration: 140 }
    }

    Text {
        anchors.centerIn: parent

        text: badge.icon
        color: badge.on ? Theme.background : Theme.textDim
        font.family: Theme.font
        font.pixelSize: Math.round(badge.diameter * 0.47)

        Behavior on color {
            ColorAnimation { duration: 140 }
        }
    }
}
