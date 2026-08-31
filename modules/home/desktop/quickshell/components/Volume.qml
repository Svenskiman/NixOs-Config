import QtQuick
import qs.services

Text {
    id: root

    readonly property bool panelOpen: Runtime.openPanel === "audio"

    text: {
        if (Audio.muted)
            return "󰝟";
        if (Audio.volume > 0.66)
            return "󰕾";
        if (Audio.volume > 0.33)
            return "󰖀";
        return "󰕿";
    }

    color: root.panelOpen ? Theme.colors.accent : Theme.colors.foreground
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    // Click opens the audio panel
    MouseArea {
        anchors.fill: parent
        onClicked: Runtime.toggle("audio")
    }
}
