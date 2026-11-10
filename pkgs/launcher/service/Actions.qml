pragma Singleton

import QtQuick
import Quickshell
import "../state"

Searcher {
    id: root

    function transformSearch(search: string): string {
        return search.slice(Config.actionPrefix.length);
    }

    list: variants.instances
    useFuzzy: Config.useFuzzyActions

    Variants {
        id: variants

        model: Config.actions.filter(a => (a.enabled ?? true) && (Config.enableDangerousActions || !a.dangerous))

        Action {}
    }

    component Action: QtObject {
        required property var modelData
        readonly property string name: modelData.name ?? "Unnamed"
        readonly property string desc: modelData.description ?? "No description"
        readonly property string icon: modelData.icon ?? "help_outline"
        readonly property list<string> command: modelData.command ?? []

        function onClicked(list: var): void {
            if (command.length === 0)
                return;

            if (command[0] === "autocomplete" && command.length > 1) {
                list.search.text = `${Config.actionPrefix}${command[1]} `;
            } else {
                Shell.open = false;
                Quickshell.execDetached(command);
            }
        }
    }
}
