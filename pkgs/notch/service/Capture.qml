pragma Singleton
import Quickshell

Singleton {
    id: root

    readonly property string icon: "󰹑"

    function region() {
        Quickshell.execDetached(["flameshot-monitor"]);
    }

    function screen() {
        Quickshell.execDetached([
            "flameshot", "full", "-c", "-p",
            Quickshell.env("HOME") + "/Pictures/Screenshots"
        ]);
    }
}
