pragma Singleton

import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // Discord is running if it has a window open
    readonly property bool running: ToplevelManager.toplevels.values.some(toplevel => toplevel.appId === "discord")

    // Mic capture means a call. Discord's audio streams come and go,
    // so they're only trusted for call state, not for running state.
    readonly property bool inCall: Pipewire.nodes.values.some(node => node.isStream && !node.isSink && node.properties?.["application.process.binary"]?.toLowerCase().includes("discord"))

    PwObjectTracker {
        objects: Pipewire.nodes.values.filter(node => node.isStream)
    }
}
