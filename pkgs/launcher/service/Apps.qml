pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../state"

Searcher {
    id: root

    property var frequencies: ({})

    readonly property var apps: {
        const freq = frequencies;
        const favs = Config.favouriteApps;
        const list = DesktopEntries.applications.values.filter(a => !a.noDisplay && !Strings.testRegexList(Config.hiddenApps, a.id)).map(a => ({
                    entry: a,
                    id: a.id,
                    name: a.name,
                    comment: a.comment,
                    genericName: a.genericName,
                    execString: a.execString,
                    startupClass: a.startupClass,
                    categories: a.categories.join(" "),
                    keywords: a.keywords.join(" "),
                    favourite: Strings.testRegexList(favs, a.id),
                    frequency: freq[a.id] ?? 0
                }));
        return list.sort((a, b) => {
            if (a.favourite !== b.favourite)
                return a.favourite ? -1 : 1;
            if (a.frequency !== b.frequency)
                return b.frequency - a.frequency;
            return a.name.localeCompare(b.name);
        });
    }

    function launch(entry: DesktopEntry): void {
        const freq = Object.assign({}, frequencies);
        freq[entry.id] = (freq[entry.id] ?? 0) + 1;
        frequencies = freq;
        store.setText(JSON.stringify(freq));

        if (entry.runInTerminal)
            Quickshell.execDetached({
                command: [...Config.terminal, "-e", ...entry.command],
                workingDirectory: entry.workingDirectory
            });
        else
            entry.execute();
    }

    function search(search: string): var {
        const prefix = Config.specialPrefix;

        if (search.startsWith(`${prefix}i `)) {
            keys = ["id", "name"];
            weights = [0.9, 0.1];
        } else if (search.startsWith(`${prefix}c `)) {
            keys = ["categories", "name"];
            weights = [0.9, 0.1];
        } else if (search.startsWith(`${prefix}d `)) {
            keys = ["comment", "name"];
            weights = [0.9, 0.1];
        } else if (search.startsWith(`${prefix}e `)) {
            keys = ["execString", "name"];
            weights = [0.9, 0.1];
        } else if (search.startsWith(`${prefix}w `)) {
            keys = ["startupClass", "name"];
            weights = [0.9, 0.1];
        } else if (search.startsWith(`${prefix}g `)) {
            keys = ["genericName", "name"];
            weights = [0.9, 0.1];
        } else if (search.startsWith(`${prefix}k `)) {
            keys = ["keywords", "name"];
            weights = [0.9, 0.1];
        } else {
            keys = ["name"];
            weights = [1];

            if (!search.startsWith(`${prefix}t `))
                return query(search).map(e => e.entry);
        }

        const results = query(search.slice(prefix.length + 2)).map(e => e.entry);
        if (search.startsWith(`${prefix}t `))
            return results.filter(a => a.runInTerminal);
        return results;
    }

    function selector(item: var): string {
        return keys.map(k => item[k]).join(" ");
    }

    list: apps
    useFuzzy: Config.useFuzzyApps

    FileView {
        id: store

        path: `${Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state"}/launcher/apps.json`
        printErrors: false
        atomicWrites: true
        onLoaded: {
            try {
                root.frequencies = JSON.parse(text());
            } catch (e) {
                root.frequencies = {};
            }
        }
    }
}
