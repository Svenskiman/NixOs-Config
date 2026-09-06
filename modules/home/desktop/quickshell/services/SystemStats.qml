pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Percentages, 0-100
    property int cpu: 0
    property int ram: 0
    property int gpu: 0
    property int vram: 0

    // False on machines with no AMD card, stats show n/a
    property bool gpuAvailable: false

    property string uptime: ""
    property string hostname: ""

    // Polling only runs while the panel is open
    property bool monitoring: false

    // Previous /proc/stat sample, used to work out the delta
    property real lastBusy: -1
    property real lastTotal: 0

    Timer {
        interval: 2000
        repeat: true
        triggeredOnStart: true

        running: root.monitoring

        onTriggered: {
            if (!cpuQuery.running)
                cpuQuery.running = true;
            if (!ramQuery.running)
                ramQuery.running = true;
            if (!gpuQuery.running)
                gpuQuery.running = true;
        }
    }

    Timer {
        interval: 60000
        repeat: true
        triggeredOnStart: true

        running: root.monitoring

        onTriggered: if (!uptimeQuery.running)
            uptimeQuery.running = true
    }

    // First line of /proc/stat: user, nice, system, idle, ...
    Process {
        id: cpuQuery

        command: ["head", "-n", "1", "/proc/stat"]

        stdout: StdioCollector {
            onStreamFinished: {
                const fields = text.trim().split(/\s+/);
                if (fields.length < 5)
                    return;

                const busy = parseFloat(fields[1]) + parseFloat(fields[2]) + parseFloat(fields[3]);
                const total = busy + parseFloat(fields[4]);

                // First sample only establishes a baseline
                if (root.lastBusy >= 0 && total > root.lastTotal) {
                    const usage = 100 * (busy - root.lastBusy) / (total - root.lastTotal);
                    root.cpu = Math.max(0, Math.min(100, Math.round(usage)));
                }

                root.lastBusy = busy;
                root.lastTotal = total;
            }
        }
    }

    Process {
        id: ramQuery

        command: ["cat", "/proc/meminfo"]

        stdout: StdioCollector {
            onStreamFinished: {
                const total = text.match(/MemTotal:\s+(\d+)/);
                const available = text.match(/MemAvailable:\s+(\d+)/);

                if (!total || !available)
                    return;

                const used = parseFloat(total[1]) - parseFloat(available[1]);
                root.ram = Math.round(100 * used / parseFloat(total[1]));
            }
        }
    }

    // AMD only. Exits non-zero on machines without a supported card.
    Process {
        id: gpuQuery

        command: ["rocm-smi", "--showmeminfo", "vram", "-u", "--json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const card = JSON.parse(text).card0;

                    const vramTotal = parseFloat(card["VRAM Total Memory (B)"]);
                    const vramUsed = parseFloat(card["VRAM Total Used Memory (B)"]);

                    root.gpu = Math.round(parseFloat(card["GPU use (%)"]));
                    root.vram = vramTotal > 0 ? Math.round(100 * vramUsed / vramTotal) : 0;
                    root.gpuAvailable = true;
                } catch (e) {
                    root.gpuAvailable = false;
                }
            }
        }

        onExited: code => {
            if (code !== 0)
                root.gpuAvailable = false;
        }
    }

    // First field is seconds since boot
    Process {
        id: uptimeQuery

        command: ["cat", "/proc/uptime"]

        stdout: StdioCollector {
            onStreamFinished: {
                const seconds = parseFloat(text.trim().split(/\s+/)[0]);
                if (isNaN(seconds))
                    return;

                const hours = Math.floor(seconds / 3600);
                const minutes = Math.floor((seconds % 3600) / 60);

                root.uptime = `Uptime: ${hours}h ${minutes}m`;
            }
        }
    }

    // Read once at startup, it can't change while the shell runs
    Process {
        id: hostnameQuery

        running: true

        command: ["hostname"]

        stdout: StdioCollector {
            onStreamFinished: root.hostname = text.trim()
        }
    }

    reloadableId: "systemStats"
}
