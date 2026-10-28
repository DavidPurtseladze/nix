import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"
import "../atoms"

// Show notifications list 
Item {
    id: list

    property string name: "notifications"
    property int radius: 24

    // Takes the keyboard once clicked, so Esc can close it.
    property bool focusable: true

    readonly property int headerHeight: 42
    readonly property int maxBodyHeight: 340

    implicitWidth: 420
    implicitHeight: headerHeight + Math.min(column.height, maxBodyHeight) + 12

    Column {
        anchors.fill: parent

        // header
        Item {
            width: parent.width
            height: list.headerHeight

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter
                spacing: 9

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰂚"
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: 14
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Notifications.count === 0
                        ? "Nothing waiting"
                        : Notifications.count + (Notifications.count === 1 ? " notification" : " notifications")
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: Notifications.count > 0
                    text: "Clear all"
                    color: clearArea.hovered ? Theme.text : Theme.textDim
                    font.family: Theme.font
                    font.pixelSize: 11

                    HoverHandler {
                        id: clearArea
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: {
                            Notifications.dismissAll();
                            Shell.clear();
                        }
                    }
                }

                CloseButton {
                    onActivated: Shell.clear()
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: Qt.rgba(1, 1, 1, 0.08)
            }
        }

        // rows
        Flickable {
            id: body

            width: parent.width
            height: Math.min(column.height, list.maxBodyHeight)
            contentHeight: column.height
            clip: true
            interactive: contentHeight > height
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: column
                width: body.width

                Repeater {
                    model: Notifications.recent

                    NotificationRow {
                        required property var modelData
                        width: column.width
                        notification: modelData
                    }
                }
            }
        }
    }
}
