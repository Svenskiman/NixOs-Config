import QtQuick
import qs.components
import qs.services

Panel {
    name: "audio"

    // Header
    Row {
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "󰕾 "
            color: Theme.colors.accent
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "Audio"
            color: Theme.colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
        }
    }

    // Divider
    Rectangle {
        width: parent.width
        height: 1
        color: Theme.colors.color8
    }

    // Output section
    Item {
        width: parent.width
        height: 18

        Text {
            anchors.left: parent.left
            text: "OUTPUT"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }

        Text {
            anchors.right: parent.right
            text: Math.round(Audio.volume * 100) + "%"
            color: Theme.colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }
    }

    Slider {
        width: parent.width
        value: Audio.volume
        onMoved: v => Audio.setVolume(v)
    }

    DeviceList {
        width: parent.width
        devices: Audio.sinks
        active: Audio.sink
        onSelected: device => Audio.setSink(device)
    }

    // Input section
    Item {
        width: parent.width
        height: 18

        Text {
            anchors.left: parent.left
            text: "INPUT"
            color: Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }

        Text {
            anchors.right: parent.right
            text: Math.round(Audio.inputVolume * 100) + "%"
            color: Theme.colors.foreground
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }
    }

    Slider {
        width: parent.width
        value: Audio.inputVolume
        onMoved: v => Audio.setInputVolume(v)
    }

    DeviceList {
        width: parent.width
        devices: Audio.sources
        active: Audio.source
        onSelected: device => Audio.setSource(device)
    }
}
