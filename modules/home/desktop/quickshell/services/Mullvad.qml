pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // connected, connecting, blocked, disconnected, or error
    property string status: "error"

    readonly property bool connected: root.status === "connected"

    function toggle() {
        const action = root.status === "disconnected" || root.status === "error" ? "connect" : "disconnect";
        Quickshell.execDetached(["mullvad", action]);
    }

    // Streams state changes, so no polling needed
    Process {
        running: true

        command: ["mullvad", "status", "listen"]

        stdout: SplitParser {
            onRead: line => {
                if (line.startsWith("Connected"))
                    root.status = "connected";
                else if (line.startsWith("Connecting"))
                    root.status = "connecting";
                else if (line.startsWith("Blocked"))
                    root.status = "blocked";
                else if (line.startsWith("Disconnect"))
                    root.status = "disconnected";
            }
        }

        onExited: root.status = "error"
    }

    reloadableId: "mullvad"
}
