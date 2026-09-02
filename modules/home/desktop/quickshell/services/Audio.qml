pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // Currently active output and input devices
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // Last known levels, held while a device switch leaves sink/source null
    property real lastVolume: 0
    property real lastInputVolume: 0

    // Output volume
    readonly property real volume: sink?.ready ? sink.audio.volume : lastVolume
    readonly property bool muted: sink?.ready ? sink.audio.muted : false

    // Input volume
    readonly property real inputVolume: source?.ready ? source.audio.volume : lastInputVolume
    readonly property bool inputMuted: source?.ready ? source.audio.muted : false

    onVolumeChanged: if (sink?.ready)
        lastVolume = volume
    onInputVolumeChanged: if (source?.ready)
        lastInputVolume = inputVolume

    // Hardware audio devices only, excluding per-application streams
    readonly property var devices: Pipewire.nodes.values.filter(node => !node.isStream && node.audio)

    // Split into outputs and inputs
    readonly property var sinks: devices.filter(node => node.isSink)
    readonly property var sources: devices.filter(node => !node.isSink)

    // Set output volume
    function setVolume(value) {
        if (sink?.audio)
            sink.audio.volume = Math.max(0, Math.min(1, value));
    }

    // Set input volume
    function setInputVolume(value) {
        if (source?.audio)
            source.audio.volume = Math.max(0, Math.min(1, value));
    }

    // Toggle output mute
    function toggleMute() {
        if (sink?.audio)
            sink.audio.muted = !sink.audio.muted;
    }

    // Toggle input mute
    function toggleInputMute() {
        if (source?.audio)
            source.audio.muted = !source.audio.muted;
    }

    // Switch the active output device
    function setSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    // Switch the active input device
    function setSource(node) {
        Pipewire.preferredDefaultAudioSource = node;
    }

    // Track active sink/source device
    PwObjectTracker {
        objects: [root.sink, root.source]
    }
}
