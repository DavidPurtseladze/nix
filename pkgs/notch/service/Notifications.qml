pragma Singleton
import Quickshell
import Quickshell.Services.Notifications

// The notification server claims a D-Bus. 
Singleton {
    id: root

    signal arrived(var n)

    property var latest: null

    readonly property var list: server.trackedNotifications
        ? server.trackedNotifications.values
        : []
    readonly property int count: list.length

    // Newest first 
    readonly property var recent: list.slice().reverse()

    NotificationServer {
        id: server

        keepOnReload: false
        bodySupported: true
        imageSupported: true
        actionsSupported: true

        onNotification: n => {
            // OSD-style notifications are dropped on the floor
            if (root.isOsd(n))
                return;

            // Without this the notification is dropped the moment we return.
            n.tracked = true;
            root.latest = n;
            root.arrived(n);
        }
    }

    readonly property var osdHints: [
        "x-canonical-private-synchronous",
        "synchronous"
    ]

    function isOsd(n) {
        if (!n || !n.hints)
            return false;
        for (let i = 0; i < osdHints.length; i++) {
            if (n.hints[osdHints[i]] !== undefined)
                return true;
        }
        return false;
    }

    function dismissAll() {
        const all = list.slice();
        for (let i = 0; i < all.length; i++)
            all[i].dismiss();
        latest = null;
    }
}
