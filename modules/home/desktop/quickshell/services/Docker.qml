pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // "error" when the daemon isn't reachable, otherwise idle or running
    property string status: "error"

    // Number of running containers
    property int count: 0

    Timer {
        interval: 10000
        repeat: true
        triggeredOnStart: true
        running: true

        onTriggered: if (!query.running)
            query.running = true
    }

    // Prints one container id per line, or fails if the daemon is down
    Process {
        id: query

        command: ["docker", "ps", "-q"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim();
                root.count = lines === "" ? 0 : lines.split("\n").length;
                root.status = root.count > 0 ? "running" : "idle";
            }
        }

        onExited: code => {
            if (code !== 0) {
                root.status = "error";
                root.count = 0;
            }
        }
    }

    reloadableId: "docker"
}
