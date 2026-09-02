pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Networking as Net

Singleton {
    id: root

    // False when NetworkManager isn't running
    readonly property bool hasBackend: Net.Networking.backend !== Net.NetworkBackendType.None

    // Software rfkill switch for all wireless devices
    readonly property bool enabled: Net.Networking.wifiEnabled

    // The wifi device, usually the only one
    readonly property var device: Net.Networking.devices.values.find(d => d.type === Net.DeviceType.Wifi) ?? null

    // Kernel name of the interface, e.g. wlan0
    readonly property string interfaceName: device?.name ?? ""

    // The wired device. Present whenever the machine has an ethernet port
    readonly property var wiredDevice: Net.Networking.devices.values.find(d => d.type === Net.DeviceType.Wired) ?? null

    // True when the cable is in and NetworkManager has the link up
    readonly property bool ethernetConnected: wiredDevice?.connected ?? false

    // Every network the scanner can see, plus any connected one
    readonly property var networks: device?.networks?.values ?? []

    // Saved networks, and everything else in range
    readonly property var known: networks.filter(network => network.known)
    readonly property var unknown: networks.filter(network => !network.known)

    // The connected network, null when down
    readonly property var active: networks.find(network => network.connected) ?? null

    // Signal strength of the connected network, 0.0 to 1.0
    readonly property real strength: active?.signalStrength ?? 0

    // Held so the header can keep naming the network after it drops
    property string lastSsid: ""

    // Header title: current network, else the last one, else a plain label
    readonly property string ssid: active?.name ?? (lastSsid !== "" ? lastSsid : "Wi-Fi")

    // Scanning is expensive, so the panel sets this only while it's open
    property bool scanning: false

    // Ping and throughput polling, likewise driven by the panel
    property bool monitoring: false

    onScanningChanged: if (device)
        device.scannerEnabled = scanning
    onDeviceChanged: {
        if (device)
            device.scannerEnabled = scanning;

        // Counters belong to the old interface, so start over
        root.lastRx = -1;
        root.lastTx = -1;
    }

    onActiveChanged: {
        if (active)
            root.lastSsid = active.name;

        addressLookup.restart();
    }

    // Filled by the route lookup below, since the API exposes no addresses
    property string ipAddress: ""
    property string gateway: ""

    // Round trip time in milliseconds, -1 when unknown
    property real ping: -1

    // Current transfer rates in bytes per second
    property real rxRate: 0
    property real txRate: 0

    // Cumulative bytes since the interface came up
    property real rxTotal: 0
    property real txTotal: 0

    // Previous counter sample, -1 before the first read
    property real lastRx: -1
    property real lastTx: -1
    property real lastSampleTime: 0

    // Connection state as text, mirroring Bluetooth.stateText
    function stateText(network) {
        return network.connected ? "true" : "false";
    }

    // Signal strength as a percentage
    function signalText(network) {
        return Math.round(network.signalStrength * 100) + "%";
    }

    // Bytes per second as a readable rate
    function formatRate(bytes) {
        if (bytes >= 1000000)
            return (bytes / 1000000).toFixed(1) + " MB/s";
        if (bytes >= 1000)
            return (bytes / 1000).toFixed(1) + " KB/s";
        return Math.round(bytes) + " B/s";
    }

    // Bytes as a readable total
    function formatTotal(bytes) {
        if (bytes >= 1000000000)
            return (bytes / 1000000000).toFixed(2) + " GB";
        if (bytes >= 1000000)
            return (bytes / 1000000).toFixed(2) + " MB";
        if (bytes >= 1000)
            return (bytes / 1000).toFixed(1) + " KB";
        return Math.round(bytes) + " B";
    }

    // Turn wifi on or off
    function setEnabled(value) {
        Net.Networking.wifiEnabled = value;
    }

    // Connect or disconnect a saved network
    function toggleNetwork(network) {
        if (network.connected)
            network.disconnect();
        else
            network.connect();
    }

    // Addresses aren't assigned the instant a connection reports up
    Timer {
        id: addressLookup

        interval: 500
        onTriggered: if (root.interfaceName !== "")
            routeQuery.running = true
    }

    // Scoped to the wifi interface with `oif`, otherwise the kernel answers
    // for the default route, which is ethernet whenever a cable is in.
    Process {
        id: routeQuery

        command: ["ip", "-j", "route", "get", "1.1.1.1", "oif", root.interfaceName]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const route = JSON.parse(text)[0];
                    root.ipAddress = route?.prefsrc ?? "";
                    root.gateway = route?.gateway ?? "";
                } catch (e) {
                    root.ipAddress = "";
                    root.gateway = "";
                }
            }
        }
    }

    // Only polls while the panel is open
    Timer {
        interval: 2000
        repeat: true
        triggeredOnStart: true

        running: root.monitoring && root.interfaceName !== ""

        onTriggered: {
            if (!counterQuery.running)
                counterQuery.running = true;

            if (root.active && !pingQuery.running)
                pingQuery.running = true;
        }
    }

    // Interface byte counters, two numbers one per line
    Process {
        id: counterQuery

        command: ["cat", `/sys/class/net/${root.interfaceName}/statistics/rx_bytes`, `/sys/class/net/${root.interfaceName}/statistics/tx_bytes`]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length < 2)
                    return;

                const rx = parseFloat(lines[0]);
                const tx = parseFloat(lines[1]);
                const now = Date.now();

                if (isNaN(rx) || isNaN(tx))
                    return;

                root.rxTotal = rx;
                root.txTotal = tx;

                // First sample only establishes a baseline
                if (root.lastRx >= 0 && now > root.lastSampleTime) {
                    const seconds = (now - root.lastSampleTime) / 1000;
                    root.rxRate = Math.max(0, (rx - root.lastRx) / seconds);
                    root.txRate = Math.max(0, (tx - root.lastTx) / seconds);
                }

                root.lastRx = rx;
                root.lastTx = tx;
                root.lastSampleTime = now;
            }
        }
    }

    // Round trip to the wifi gateway. Bound to the interface so a wired
    // connection can't answer for it.
    Process {
        id: pingQuery

        command: ["ping", "-c", "1", "-W", "1", "-n", root.gateway !== "" ? root.gateway : "1.1.1.1"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/time=([\d.]+)/);
                root.ping = match ? parseFloat(match[1]) : -1;
            }
        }
    }

    Component.onCompleted: addressLookup.restart()

    reloadableId: "network"
}
