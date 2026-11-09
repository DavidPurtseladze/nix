import QtQuick
import "../theme"
import "../atoms"

Item {
    id: row

    property var device: null

    readonly property bool connected: device ? device.connected : false
    readonly property bool paired: device && (device.paired || device.bonded)
    readonly property bool busy: device ? device.pairing : false

    implicitHeight: 40

    HoverHandler {
        id: pointer
        cursorShape: Qt.PointingHandCursor
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: 9
        color: row.connected
            ? Qt.rgba(1, 1, 1, 0.07)
            : (pointer.hovered ? Theme.surface : "transparent")

        Behavior on color {
            ColorAnimation { duration: 110 }
        }
    }

    TapHandler {
        onTapped: {
            if (!row.device)
                return;
            if (row.connected)
                row.device.disconnect();
            else if (row.paired)
                row.device.connect();
            else
                row.device.pair();
        }
    }

    Text {
        id: glyph

        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 18
        horizontalAlignment: Text.AlignHCenter

        text: {
            const icon = row.device ? row.device.icon : "";
            if (icon.indexOf("headset") >= 0 || icon.indexOf("headphone") >= 0)
                return "󰋋";
            if (icon.indexOf("audio") >= 0)
                return "󰓃";
            if (icon.indexOf("mouse") >= 0)
                return "󰍽";
            if (icon.indexOf("keyboard") >= 0)
                return "󰌌";
            if (icon.indexOf("phone") >= 0)
                return "󰄜";
            if (icon.indexOf("computer") >= 0)
                return "󰟀";
            return "󰂯";
        }
        color: row.connected ? Theme.accent : Theme.textDim
        font.family: Theme.font
        font.pixelSize: 14
    }

    Column {
        anchors.left: glyph.right
        anchors.leftMargin: 10
        anchors.right: trailing.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 1

        Text {
            width: parent.width
            text: row.device
                ? (row.device.name !== "" ? row.device.name : row.device.address)
                : ""
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 12
            font.weight: row.connected ? Font.DemiBold : Font.Normal
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            visible: text !== ""
            text: {
                if (row.busy)
                    return "Pairing…";
                if (row.connected)
                    return row.device && row.device.batteryAvailable
                        ? "Connected · " + Math.round(row.device.battery * 100) + "%"
                        : "Connected";
                if (row.paired)
                    return "Paired";
                return "";
            }
            color: Theme.textDim
            font.family: Theme.font
            font.pixelSize: 10
            elide: Text.ElideRight
        }
    }

    Row {
        id: trailing

        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        height: row.height
        spacing: 8

        Spinner {
            height: trailing.height
            verticalAlignment: Text.AlignVCenter
            visible: row.busy
        }

        Text {
            height: trailing.height
            verticalAlignment: Text.AlignVCenter
            visible: row.paired && pointer.hovered
            text: "Forget"
            color: forget.hovered ? Theme.text : Theme.textDim
            font.family: Theme.font
            font.pixelSize: 10

            HoverHandler {
                id: forget
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                gesturePolicy: TapHandler.ReleaseWithinBounds
                onTapped: if (row.device) row.device.forget()
            }
        }
    }
}
