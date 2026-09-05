pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // "Running" when up, "Stopped" when down, empty before the first read
    property string backendState: ""

    // This machine's tailnet IPv4
    property string address: ""

    // Other machines: { name, address, online }
    property var devices: []

    // Polling only runs while the panel is open
    property bool monitoring: false

    readonly property bool enabled: root.backendState === "Running"

    function setEnabled(value) {
        Quickshell.execDetached(["tailscale", value ? "up" : "down"]);
        refresh.restart();
    }

    Timer {
        interval: 3000
        repeat: true
        triggeredOnStart: true

        running: root.monitoring

        onTriggered: if (!query.running)
            query.running = true
    }

    // Re-reads shortly after a toggle, since the daemon takes a moment
    Timer {
        id: refresh

        interval: 1000
        onTriggered: if (!query.running)
            query.running = true
    }

    Process {
        id: query

        command: ["tailscale", "status", "--json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const status = JSON.parse(text);

                    root.backendState = status.BackendState ?? "";
                    root.address = status.Self?.TailscaleIPs?.[0] ?? "";

                    root.devices = Object.values(status.Peer ?? {}).map(peer => ({
                                name: (peer.DNSName ?? "").split(".")[0] || peer.HostName || "",
                                address: peer.TailscaleIPs?.[0] ?? "",
                                online: peer.Online === true
                            })).sort((a, b) => a.name.localeCompare(b.name));
                } catch (e) {
                    root.backendState = "";
                    root.devices = [];
                }
            }
        }

        onExited: code => {
            if (code !== 0) {
                root.backendState = "";
                root.devices = [];
            }
        }
    }

    reloadableId: "tailscale"
}
