import QtQuick
import "../theme"
import "../service"

Rectangle {
    id: strip

    implicitHeight: 56
    radius: 12
    color: Theme.surface

    Rectangle {
        id: art

        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter

        width: 40
        height: 40
        radius: 8
        color: Qt.rgba(1, 1, 1, 0.08)
        clip: true

        Image {
            anchors.fill: parent
            visible: Media.art !== ""
            source: Media.art
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
        }

        Text {
            anchors.centerIn: parent
            visible: Media.art === ""
            text: "󰎈"
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 16
        }
    }

    Column {
        anchors.left: art.right
        anchors.leftMargin: 10
        anchors.right: transport.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
            width: parent.width
            text: Media.title
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 12
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: text !== ""
            text: Media.artist
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 10
            elide: Text.ElideRight
        }
    }

    Row {
        id: transport

        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        height: strip.height
        spacing: 2

        MediaButton {
            height: transport.height
            glyph: "󰒮"
            active: Media.player && Media.player.canGoPrevious

            onActivated: Media.previous()
        }

        MediaButton {
            height: transport.height
            glyph: Media.icon
            size: 17
            active: Media.player && Media.player.canTogglePlaying

            onActivated: Media.toggle()
        }

        MediaButton {
            height: transport.height
            glyph: "󰒭"
            active: Media.player && Media.player.canGoNext

            onActivated: Media.next()
        }
    }
}
