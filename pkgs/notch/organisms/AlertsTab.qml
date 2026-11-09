import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"

Column {
    id: tab

    spacing: 0

    Item {
        width: parent.width
        height: 30
        visible: Notifications.count > 0

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter

            text: Notifications.count
                + (Notifications.count === 1 ? " notification" : " notifications")
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 10
            font.weight: Font.DemiBold
            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.6
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.verticalCenter: parent.verticalCenter

            visible: Notifications.count > 0
            text: "Clear all"
            color: clear.hovered ? Theme.text : Theme.textDim
            font.family: Theme.font
            font.pixelSize: 11

            HoverHandler {
                id: clear
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                onTapped: Notifications.dismissAll()
            }
        }
    }

    Repeater {
        model: Notifications.recent

        NotificationRow {
            required property var modelData

            width: tab.width
            notification: modelData
        }
    }

    Item {
        width: parent.width
        height: 90
        visible: Notifications.count === 0

        Column {
            anchors.centerIn: parent
            spacing: 6

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "󰂚"
                color: Theme.track
                font.family: Theme.font
                font.pixelSize: 20
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "You are all caught up"
                color: Theme.textDim
                font.family: Theme.font
                font.pixelSize: 11
            }
        }
    }
}
