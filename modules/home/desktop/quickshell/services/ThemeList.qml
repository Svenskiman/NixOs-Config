pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Preview images live alongside the shell config
    readonly property string previewRoot: `${Quickshell.env("HOME")}/.config/quickshell/nixshell/assets/themes`

    // Theme names, e.g. ["everforest", "gruvbox", ...]
    property var names: []

    // Name of the active theme
    property string current: ""

    // Index of `current` within `names`, 0 when not found
    readonly property int currentIndex: Math.max(0, root.names.indexOf(root.current))

    function preview(name) {
        return `${root.previewRoot}/${name}.png`;
    }

    function apply(name) {
        Quickshell.execDetached(["nix-theme-set", name]);
    }

    // Active theme name. Watched, so the carousel follows external changes.
    FileView {
        id: activeTheme

        path: `${Quickshell.env("HOME")}/.local/state/theme/active-theme`

        watchChanges: true
        preload: true

        onLoaded: {
            root.current = activeTheme.text().trim();

            if (!scan.running)
                scan.running = true;
        }

        onFileChanged: {
            activeTheme.reload();
            root.current = activeTheme.text().trim();
        }
    }

    // Every theme gets a directory under ~/.config/themes at build time
    Process {
        id: scan

        command: ["find", `${Quickshell.env("HOME")}/.config/themes`, "-mindepth", "1", "-maxdepth", "1", "-type", "d", "-printf", "%f\n"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim();
                root.names = lines === "" ? [] : lines.split("\n").sort();
            }
        }
    }

    reloadableId: "themeList"
}
