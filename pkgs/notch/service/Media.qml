pragma Singleton
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property var players: Mpris.players ? Mpris.players.values : []

    readonly property var player: {
        const list = players;
        for (let i = 0; i < list.length; i++) {
            if (list[i].isPlaying)
                return list[i];
        }
        for (let i = 0; i < list.length; i++) {
            if (list[i].canControl)
                return list[i];
        }
        return null;
    }

    readonly property bool available: player !== null
    readonly property bool playing: player ? player.isPlaying : false

    readonly property string title: player && player.trackTitle !== ""
        ? player.trackTitle
        : (player ? player.identity : "")

    readonly property string artist: player ? player.trackArtist : ""
    readonly property string art: player ? player.trackArtUrl : ""
    readonly property string source: player ? player.identity : ""

    readonly property string icon: playing ? "󰏤" : "󰐊"

    function toggle() {
        if (player && player.canTogglePlaying)
            player.togglePlaying();
    }

    function next() {
        if (player && player.canGoNext)
            player.next();
    }

    function previous() {
        if (player && player.canGoPrevious)
            player.previous();
    }
}
