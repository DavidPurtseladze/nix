pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../state"

Searcher {
    id: root

    property var palettes: []
    property string current

    function prefixFor(text: string): string {
        for (const p of Config.themePrefixes)
            if (text.startsWith(`${Config.actionPrefix}${p} `))
                return `${Config.actionPrefix}${p} `;
        return "";
    }

    function transformSearch(search: string): string {
        for (const p of Config.themePrefixes) {
            const prefix = `${Config.actionPrefix}${p}`;
            if (search === prefix || search.startsWith(`${prefix} `))
                return search.slice(prefix.length).trim();
        }
        return search;
    }

    function reload(): void {
        getPalettes.running = true;
        getCurrent.running = true;
    }

    function apply(scheme: string): void {
        Shell.open = false;
        Quickshell.execDetached(scheme === "auto" ? ["theme", "auto"] : ["theme", "set", scheme]);
        current = scheme;
    }

    list: palettes
    useFuzzy: Config.useFuzzyThemes
    keys: ["name", "scheme"]
    weights: [0.9, 0.1]

    Process {
        id: getPalettes

        running: true
        command: ["theme", "palettes", "all"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.palettes = JSON.parse(text);
                } catch (e) {
                    root.palettes = [];
                }
            }
        }
    }

    Process {
        id: getCurrent

        running: true
        command: ["theme", "current"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const c = JSON.parse(text);
                    root.current = c.mode === "auto" ? "auto" : (c.scheme ?? "");
                } catch (e) {
                    root.current = "";
                }
            }
        }
    }
}
