pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Change this one line when the wallpapers move off the config dir
    readonly property string wallpaperRoot: `${Quickshell.env("HOME")}/.config/nixconf/assets/wallpapers`

    // Absolute paths, sorted
    property var images: []

    // Path of the wallpaper currently displayed
    property string current: ""

    // Index of `current` within `images`, 0 when not found
    readonly property int currentIndex: Math.max(0, root.images.indexOf(root.current))

    // Re-reads the image list and the current wallpaper
    function refresh() {
        root.rescan();

        if (!currentQuery.running)
            currentQuery.running = true;
    }

    function rescan() {
        const theme = themeFile.text().trim();
        if (theme === "")
            return;

        imageQuery.command = ["find", `${root.wallpaperRoot}/${theme}`, "-maxdepth", "1", "-type", "f", "-name", "*.png", "-o", "-name", "*.jpg", "-o", "-name", "*.jpeg", "-o", "-name", "*.gif"];
        imageQuery.running = true;
    }

    function apply(path) {
        Quickshell.execDetached(["awww", "img", path, "--transition-type", "fade"]);
        root.current = path;
    }

    // Name of the active theme, e.g. "everforest".
    // Watched, so switching themes rescans and the preloader warms the new set.
    FileView {
        id: themeFile

        path: `${Quickshell.env("HOME")}/.local/state/theme/active-theme`

        watchChanges: true
        preload: true

        onLoaded: root.refresh()
        onFileChanged: {
            themeFile.reload();
            root.refresh();
        }
    }

    Process {
        id: imageQuery

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim();
                root.images = lines === "" ? [] : lines.split("\n").sort();
            }
        }
    }

    // Only the first monitor's line is read, all monitors show the same image
    Process {
        id: currentQuery

        command: ["awww", "query"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/currently displaying: image: (.+)/);
                root.current = match ? match[1].trim() : "";
            }
        }
    }

    reloadableId: "wallpaper"
}
