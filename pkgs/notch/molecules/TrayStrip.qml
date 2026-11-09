import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../theme"

Item {
    id: strip

    readonly property var items: SystemTray.items ? SystemTray.items.values : []

    implicitHeight: 26

    Text {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        visible: strip.items.length === 0
        text: "Nothing in the tray"
        color: Theme.textDim
        font.family: Theme.font
        font.pixelSize: 10
    }

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: strip.height
        spacing: 4

        Repeater {
            model: strip.items

            Rectangle {
                id: cell

                required property var modelData

                width: 26
                height: 26
                radius: 8
                y: (strip.height - height) / 2

                color: pointer.hovered ? Theme.surfaceHover : "transparent"

                Behavior on color {
                    ColorAnimation { duration: 110 }
                }

                Image {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    source: cell.modelData.icon
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                }

                HoverHandler {
                    id: pointer
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onTapped: eventPoint => {
                        if (point.pressedButtons === Qt.RightButton
                                || cell.modelData.onlyMenu)
                            cell.modelData.display(cell, cell.width / 2, cell.height);
                        else
                            cell.modelData.activate();
                    }
                }
            }
        }
    }
}
