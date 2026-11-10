pragma ComponentBehavior: Bound

import QtQuick
import "../state"
import "../service"
import "../theme"
import "../molecules"

Item {
    id: root

    required property real maxHeight

    readonly property int padding: Tokens.padding.large
    readonly property int rounding: Tokens.rounding.extraLarge

    implicitWidth: listWrapper.width + padding * 2
    implicitHeight: search.height + listWrapper.height + padding + search.anchors.bottomMargin

    Item {
        id: listWrapper

        implicitWidth: list.width
        implicitHeight: list.height + root.padding

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: search.top
        anchors.bottomMargin: root.padding

        ContentList {
            id: list

            maxHeight: root.maxHeight - search.implicitHeight - root.padding * 3
            search: search
        }
    }

    SearchBar {
        id: search

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding

        topPadding: Math.round((Tokens.padding.medium + Tokens.padding.large) / 2)
        bottomPadding: Math.round((Tokens.padding.medium + Tokens.padding.large) / 2)

        placeholderText: `Type "${Config.actionPrefix}" for commands`

        onAccepted: {
            const currentItem = list.currentList?.currentItem;
            if (currentItem) {
                if (text.startsWith(Config.actionPrefix)) {
                    if (text.startsWith(`${Config.actionPrefix}calc `))
                        currentItem.onClicked();
                    else if (Themes.prefixFor(text))
                        Themes.apply(currentItem.modelData.scheme);
                    else if (Clipboard.prefixFor(text))
                        Clipboard.copy(currentItem.modelData);
                    else
                        currentItem.modelData.onClicked(list.currentList);
                } else {
                    Apps.launch(currentItem.modelData);
                    Shell.open = false;
                }
            }
        }

        Keys.onUpPressed: list.currentList?.decrementCurrentIndex()
        Keys.onDownPressed: list.currentList?.incrementCurrentIndex()

        Keys.onEscapePressed: Shell.open = false

        Keys.onPressed: event => {
            if (!Config.vimKeybinds)
                return;

            if (event.modifiers & Qt.ControlModifier) {
                if (event.key === Qt.Key_J || event.key === Qt.Key_N) {
                    list.currentList?.incrementCurrentIndex();
                    event.accepted = true;
                } else if (event.key === Qt.Key_K || event.key === Qt.Key_P) {
                    list.currentList?.decrementCurrentIndex();
                    event.accepted = true;
                }
            } else if (event.key === Qt.Key_Tab) {
                list.currentList?.incrementCurrentIndex();
                event.accepted = true;
            } else if (event.key === Qt.Key_Backtab) {
                list.currentList?.decrementCurrentIndex();
                event.accepted = true;
            }
        }

        Component.onCompleted: {
            text = Shell.initialText;
            Shell.initialText = "";
            forceActiveFocus();
        }

        Connections {
            function onOpenChanged(): void {
                if (!Shell.open) {
                    search.text = "";
                } else {
                    if (Shell.initialText) {
                        search.text = Shell.initialText;
                        Shell.initialText = "";
                    }
                    search.forceActiveFocus();
                }
            }

            target: Shell
        }
    }
}
