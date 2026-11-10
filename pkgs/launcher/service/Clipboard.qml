pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../state"

Searcher {
    id: root

    property var entries: []

    function prefixFor(text: string): string {
        for (const p of Config.clipboardPrefixes) {
            const prefix = `${Config.actionPrefix}${p}`;
            if (text === prefix || text.startsWith(`${prefix} `))
                return prefix;
        }
        return "";
    }

    function transformSearch(search: string): string {
        const prefix = prefixFor(search);
        return prefix ? search.slice(prefix.length).trim() : search;
    }

    function reload(): void {
        proc.running = true;
    }

    function copy(entry: var): void {
        Shell.open = false;
        Quickshell.execDetached(["sh", "-c", "printf '%s' \"$1\" | cliphist decode | wl-copy", "sh", entry.raw]);
    }

    list: entries
    key: "text"

    Process {
        id: proc

        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.entries = text.split("\n").filter(l => l.length > 0).map(line => {
                    const tab = line.indexOf("\t");
                    const preview = tab >= 0 ? line.slice(tab + 1) : line;
                    const image = /^\[\[ binary data .* \]\]$/.test(preview);
                    return {
                        id: tab >= 0 ? line.slice(0, tab) : "",
                        raw: line,
                        text: preview,
                        image: image,
                        detail: image ? preview.replace(/^\[\[ binary data /, "").replace(/ \]\]$/, "") : `${preview.length} characters`
                    };
                });
            }
        }
    }
}
