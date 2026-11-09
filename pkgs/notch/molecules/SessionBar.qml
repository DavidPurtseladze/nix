import QtQuick
import "../theme"
import "../state"
import "../service"

Row {
    id: bar

    spacing: 7

    readonly property var entries: [
        { text: "Lock",    icon: "󰌾", act: () => Power.lock() },
        { text: "Suspend", icon: "󰤄", act: () => Power.suspend() },
        { text: "Reboot",  icon: "󰜉", act: () => Power.reboot() },
        { text: "Power",   icon: "󰐥", act: () => Power.off() }
    ]

    Repeater {
        model: bar.entries

        Rectangle {
            required property var modelData

            width: (bar.width - bar.spacing * (bar.entries.length - 1))
                / bar.entries.length
            height: 30
            radius: 9
            color: pointer.hovered ? Theme.surfaceHover : Theme.surface

            Behavior on color {
                ColorAnimation { duration: 110 }
            }

            Row {
                anchors.centerIn: parent
                spacing: 6

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.icon
                    color: pointer.hovered ? Theme.text : Theme.textDim
                    font.family: Theme.font
                    font.pixelSize: 12
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData.text
                    color: pointer.hovered ? Theme.text : Theme.textDim
                    font.family: Theme.font
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                }
            }

            HoverHandler {
                id: pointer
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                onTapped: {
                    Shell.clear();
                    modelData.act();
                }
            }
        }
    }
}
