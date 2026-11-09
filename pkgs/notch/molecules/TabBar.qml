import QtQuick
import "../theme"

Item {
    id: bar

    property var tabs: []
    property string current: ""

    signal picked(string value)

    implicitHeight: 26

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Repeater {
            model: bar.tabs

            Rectangle {
                required property var modelData

                readonly property bool selected: modelData.value === bar.current

                width: 46
                height: 26
                radius: 13

                color: selected
                    ? Qt.rgba(1, 1, 1, 0.12)
                    : (pointer.hovered ? Theme.surface : "transparent")

                Behavior on color {
                    ColorAnimation { duration: 110 }
                }

                Text {
                    anchors.centerIn: parent

                    text: modelData.icon ? modelData.icon : modelData.text
                    color: selected
                        ? Theme.accent
                        : (pointer.hovered ? Theme.text : Theme.textDim)
                    font.family: Theme.font
                    font.pixelSize: 15

                    Behavior on color {
                        ColorAnimation { duration: 110 }
                    }
                }

                HoverHandler {
                    id: pointer
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: bar.picked(modelData.value)
                }
            }
        }
    }
}
