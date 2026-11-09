import QtQuick
import "../theme"

Text {
    property bool lit: false

    text: "󰅂"
    color: lit ? Theme.text : Theme.textDim
    font.family: Theme.font
    font.pixelSize: 11

    Behavior on color {
        ColorAnimation { duration: 110 }
    }
}
