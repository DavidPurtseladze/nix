pragma Singleton
import Quickshell

// Global Mutable State
Singleton {
    id: root

    property bool wantsAudio: false
    property bool wantsNotification: false
    property bool listOpen: false

    readonly property string notchState: {
        if (wantsAudio)
            return "audio";
        if (listOpen)
            return "notifications";
        if (wantsNotification)
            return "notification";
        return "default";
    }

    function clear() {
        wantsNotification = false;
        listOpen = false;
    }
}
