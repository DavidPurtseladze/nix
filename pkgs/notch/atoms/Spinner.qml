import QtQuick
import "../theme"

Text {
    id: spinner

    property int frame: 0

    readonly property var frames: ["󰪞", "󰪟", "󰪠", "󰪡", "󰪢", "󰪣", "󰪤", "󰪥"]

    text: frames[frame % frames.length]
    color: Theme.textDim
    font.family: Theme.font
    font.pixelSize: 12

    Timer {
        interval: 90
        running: spinner.visible
        repeat: true
        onTriggered: spinner.frame++
    }
}
