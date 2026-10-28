import QtQuick
import "../state"
import "../theme"
import "../service"
import "../atoms"

Item {
    id: row

    property var notification: null

    readonly property var actions: notification && notification.actions
        ? notification.actions
        : []

    implicitHeight: content.height + 22

    // Hover is a HoverHandler so the buttons inside cannot steal it
    HoverHandler {
        id: pointer
    }

    Rectangle {
        anchors.fill: parent
        color: pointer.hovered ? Qt.rgba(1, 1, 1, 0.05) : "transparent"

        Behavior on color {
            ColorAnimation { duration: 110 }
        }
    }

    Column {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 18
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Row {
            width: parent.width
            spacing: 12

            Column {
                width: parent.width - 24 - 12
                spacing: 2

                Text {
                    width: parent.width
                    text: row.notification ? row.notification.summary : ""
                    textFormat: Text.PlainText
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    visible: text !== ""
                    text: row.notification ? row.notification.body : ""
                    // The spec allows <b> <i> <u> <a> in bodies
                    textFormat: Text.StyledText
                    color: Theme.textDim
                    font.family: Theme.font
                    font.pixelSize: 11
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    text: row.notification ? row.notification.appName : ""
                    color: Theme.textDim
                    font.family: Theme.fontMono
                    font.pixelSize: 10
                }
            }

            CloseButton {
                opacity: pointer.hovered ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 110 }
                }

                onActivated: if (row.notification) row.notification.dismiss()
            }
        }

        Row {
            width: parent.width
            spacing: 7
            visible: row.actions.length > 0

            Repeater {
                model: row.actions

                ActionButton {
                    required property var modelData
                    required property int index

                    text: modelData.text
                    primary: index === 0
                    height: 26
                    width: 110

                    onActivated: {
                        modelData.invoke();
                        if (row.notification)
                            row.notification.dismiss();
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 36
        height: 1
        color: Qt.rgba(1, 1, 1, 0.05)
    }
}
