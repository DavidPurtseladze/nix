import QtQuick
import "../theme"

Rectangle {
    id: bar

    property var options: []
    property var current: null

    signal picked(var value)

    implicitHeight: 28
    radius: 9
    color: Theme.surface

    readonly property int index: {
        for (let i = 0; i < options.length; i++) {
            if (options[i].value === current)
                return i;
        }
        return -1;
    }

    readonly property real slot: options.length > 0
        ? (width - 6) / options.length
        : 0

    Rectangle {
        visible: bar.index >= 0
        x: 3 + bar.index * bar.slot
        y: 3
        width: bar.slot
        height: parent.height - 6
        radius: 7
        color: Theme.accent

        Behavior on x {
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
    }

    Row {
        anchors.fill: parent
        anchors.margins: 3

        Repeater {
            model: bar.options

            Item {
                required property var modelData
                required property int index

                width: bar.slot
                height: parent.height

                readonly property bool selected: index === bar.index

                Row {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: text !== ""
                        text: modelData.icon ? modelData.icon : ""
                        color: selected ? Theme.background : Theme.textDim
                        font.family: Theme.font
                        font.pixelSize: 12
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.text
                        color: selected
                            ? Theme.background
                            : (pointer.hovered ? Theme.text : Theme.textDim)
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
                    onTapped: bar.picked(modelData.value)
                }
            }
        }
    }
}
