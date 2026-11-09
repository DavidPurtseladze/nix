import QtQuick
import "../state"
import "../theme"
import "../service"
import "../molecules"

// List of notification (popup), shows only 5
Item {
    id: notif

    property string name: "notification"
    property int radius: 20

    // Takes the keyboard once clicked, so Esc can close it.
    property bool focusable: true

    readonly property int maxVisible: 5
    readonly property var shown: Notifications.recent.slice(0, maxVisible)
    readonly property int hidden: Math.max(0, Notifications.count - maxVisible)

    // Anything waiting on an answer keeps the stack open.
    readonly property bool needsAnswer: {
        for (let i = 0; i < shown.length; i++) {
            const a = shown[i].actions;
            if (a && a.length > 0)
                return true;
        }
        return false;
    }

    implicitWidth: 400
    implicitHeight: stack.height + (hidden > 0 ? more.height : 0)

    Connections {
        target: Notifications

        function onArrived(incoming) {
            Shell.wantsNotification = true;
            notif.deadline = Date.now() + notif.lifetime;
        }
    }

    HoverHandler {
        id: pointer
    }

    // Reading it, or answering it, keeps it open.
    readonly property bool held: pointer.hovered || needsAnswer

    property int lifetime: 5000
    property double deadline: 0

    // Polled deadline, not hover edges: one flickered edge closed the stack.
    Timer {
        id: hide

        interval: 250
        repeat: true
        // Keeps counting under the OSD; `visible` so only the on-screen copy times out.
        running: Shell.wantsNotification && notif.visible

        onTriggered: {
            if (notif.held)
                notif.deadline = Date.now() + notif.lifetime;
            else if (Date.now() >= notif.deadline)
                Shell.wantsNotification = false;
        }
    }

    // Right or middle click anywhere clears the stack — no aiming required.
    TapHandler {
        acceptedButtons: Qt.RightButton | Qt.MiddleButton
        gesturePolicy: TapHandler.ReleaseWithinBounds

        onTapped: {
            Notifications.dismissAll();
            Shell.clear();
        }
    }

    Column {
        id: stack
        width: parent.width

        Repeater {
            model: notif.shown

            NotificationRow {
                required property var modelData
                width: stack.width
                notification: modelData
            }
        }
    }

    // "+3 more" — click to see everything.
    Item {
        id: more

        anchors.top: stack.bottom
        width: parent.width
        height: 30
        visible: notif.hidden > 0

        Text {
            anchors.centerIn: parent
            text: "+" + notif.hidden + " more"
            color: moreArea.hovered ? Theme.text : Theme.textDim
            font.family: Theme.font
            font.pixelSize: 11
        }

        HoverHandler {
            id: moreArea
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            onTapped: Shell.open("alerts")
        }
    }
}
