pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string statePath: `${Quickshell.env("HOME")}/.local/state/theme`
    readonly property string themesPath: `${Quickshell.env("HOME")}/.config/themes`

    readonly property string themeName: activeFile.text().trim()

    readonly property var theme: JSON.parse(themeFile.text())
    readonly property var colors: theme.colors
    readonly property var semantic: theme.semantic

    FileView {
        id: activeFile
        path: `${root.statePath}/active-theme`
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: themeFile
        path: `${root.themesPath}/${root.themeName}/quickshell.json`
        blockAllReads: true
        watchChanges: true
        onFileChanged: reload()
    }
}
