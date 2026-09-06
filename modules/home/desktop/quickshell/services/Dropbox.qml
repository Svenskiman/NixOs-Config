pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // synced, syncing, paused, or error when the daemon isn't running
    property string status: "error"

    Timer {
        interval: 3000
        repeat: true
        triggeredOnStart: true
        running: true

        onTriggered: if (!query.running)
            query.running = true
    }

    Process {
        id: query

        command: ["dropbox", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.toLowerCase();

                if (output.includes("up to date"))
                    root.status = "synced";
                else if (/syncing|downloading|uploading|indexing|starting|connecting/.test(output))
                    root.status = "syncing";
                else if (output.includes("paused"))
                    root.status = "paused";
                else
                    root.status = "error";
            }
        }

        onExited: code => {
            if (code !== 0)
                root.status = "error";
        }
    }

    reloadableId: "dropbox"
}
