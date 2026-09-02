pragma Singleton

import Quickshell
import Quickshell.Bluetooth as Bt

Singleton {
    id: root

    // The system's bluetooth adapter, usually the only one
    readonly property var adapter: Bt.Bluetooth.defaultAdapter

    // Adapter power state
    property bool enabled: adapter?.enabled ?? false

    // Every known device, paired or not
    readonly property var devices: Bt.Bluetooth.devices.values

    // Devices we've paired with before
    readonly property var paired: devices.filter(device => device.paired)

    // Anything currently connected
    readonly property var connected: devices.filter(device => device.connected)

    // True while a connection change is in flight
    function isBusy(device) {
        return device.state === Bt.BluetoothDeviceState.Connecting || device.state === Bt.BluetoothDeviceState.Disconnecting;
    }

    // Human readable connection state
    function stateText(device) {
        if (device.state === Bt.BluetoothDeviceState.Connecting)
            return "connecting";

        if (device.state === Bt.BluetoothDeviceState.Disconnecting)
            return "disconnecting";

        return device.connected ? "true" : "false";
    }

    // Turn the adapter on or off
    function setEnabled(value) {
        if (adapter)
            adapter.enabled = value;
    }

    // Connect or disconnect, ignoring clicks while a change is in flight
    function toggleDevice(device) {
        if (isBusy(device))
            return;

        if (device.connected)
            device.disconnect();
        else
            device.connect();
    }
}
