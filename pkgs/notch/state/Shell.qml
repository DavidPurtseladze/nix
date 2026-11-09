pragma Singleton
import Quickshell

// Global Mutable State
Singleton {
    id: root

    property bool wantsAudio: false
    property bool wantsNotification: false
    property bool settingsOpen: false

    property string settingsTab: "control"
    property string settingsPage: ""
    property var joinTarget: null

    readonly property string notchState: {
        if (wantsAudio)
            return "audio";
        if (settingsOpen)
            return settingsPage !== "" ? "settings." + settingsPage : "settings";
        if (wantsNotification)
            return "notification";
        return "default";
    }

    function open(tab) {
        settingsOpen = true;
        settingsPage = "";
        settingsTab = tab;
    }

    function back() {
        if (joinTarget !== null)
            joinTarget = null;
        else if (settingsOpen && settingsPage !== "")
            settingsPage = "";
        else
            clear();
    }

    function clear() {
        joinTarget = null;
        wantsNotification = false;
        settingsOpen = false;
        settingsPage = "";
        settingsTab = "control";
    }
}
