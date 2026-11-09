import QtQuick
import "../theme"
import "../service"

Rectangle {
    id: card

    implicitHeight: 92
    radius: 14
    color: Theme.surface

    property real elapsed: 0

    readonly property real span: Media.player && Media.player.lengthSupported
        ? Media.player.length
        : 0

    readonly property real progress: span > 0
        ? Math.max(0, Math.min(1, elapsed / span))
        : 0

    function resync() {
        card.elapsed = Media.player && Media.player.positionSupported
            ? Media.player.position
            : 0;
    }

    readonly property bool scrubbable: Media.player
        && Media.player.lengthSupported
        && Media.player.positionSupported
        && Media.player.length > 0

    function clock(seconds) {
        if (!isFinite(seconds) || seconds < 0)
            return "0:00";
        const total = Math.floor(seconds);
        const m = Math.floor(total / 60);
        const s = total % 60;
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    onVisibleChanged: if (visible) resync()

    Connections {
        target: Media

        function onTitleChanged() { card.resync(); }
        function onPlayingChanged() { card.resync(); }
    }

    Timer {
        interval: 1000
        running: card.visible && Media.playing && card.scrubbable
        repeat: true
        onTriggered: card.elapsed = Math.min(card.elapsed + 1, card.span)
    }

    Rectangle {
        id: art

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        width: 64
        height: 64
        radius: 10
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
            font.pixelSize: 24
        }
    }

    Item {
        anchors.left: art.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 12
        anchors.bottomMargin: 10

        Text {
            id: title

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            text: Media.title
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
            elide: Text.ElideRight
        }

        Text {
            id: artist

            anchors.top: title.bottom
            anchors.topMargin: 2
            anchors.left: parent.left
            anchors.right: parent.right

            visible: text !== ""
            text: Media.artist
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 10
            elide: Text.ElideRight
        }

        Row {
            id: transport

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: 28
            spacing: 4

            MediaButton {
                height: transport.height
                glyph: "󰒮"
                size: 16
                active: Media.player && Media.player.canGoPrevious

                onActivated: Media.previous()
            }

            MediaButton {
                height: transport.height
                glyph: Media.icon
                size: 22
                active: Media.player && Media.player.canTogglePlaying

                onActivated: Media.toggle()
            }

            MediaButton {
                height: transport.height
                glyph: "󰒭"
                size: 16
                active: Media.player && Media.player.canGoNext

                onActivated: Media.next()
            }
        }

        Item {
            anchors.bottom: parent.bottom
            anchors.left: transport.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            height: 28

            visible: card.scrubbable

            Text {
                id: elapsed

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                text: card.clock(card.elapsed)
                color: Theme.textDim
                font.family: Theme.fontMono
                font.pixelSize: 9
            }

            Text {
                id: total

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                text: card.clock(card.span)
                color: Theme.textDim
                font.family: Theme.fontMono
                font.pixelSize: 9
            }

            Rectangle {
                id: track

                anchors.left: elapsed.right
                anchors.leftMargin: 8
                anchors.right: total.left
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter

                height: 3
                radius: 1.5
                color: Theme.track

                Rectangle {
                    width: parent.width * card.progress
                    height: parent.height
                    radius: parent.radius
                    color: Theme.text
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: point => {
                        if (!Media.player || !Media.player.canSeek)
                            return;
                        const ratio = Math.max(0, Math.min(1,
                            point.position.x / track.width));
                        const target = ratio * card.span;
                        Media.player.position = target;
                        card.elapsed = target;
                    }
                }
            }
        }
    }
}
