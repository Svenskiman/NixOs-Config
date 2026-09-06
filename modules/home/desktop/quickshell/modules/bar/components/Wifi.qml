import QtQuick
import qs.services

Text {
    id: root

    readonly property bool panelOpen: Runtime.openPanel === "wifi"

    text: {
        if (!Network.enabled)
            return "󰤮";
        if (!Network.active)
            return "󰤯";
        if (Network.strength > 0.75)
            return "󰤨";
        if (Network.strength > 0.5)
            return "󰤥";
        if (Network.strength > 0.25)
            return "󰤢";
        return "󰤟";
    }

    color: root.panelOpen ? Theme.colors.accent : Theme.colors.foreground
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    // Click opens the wifi panel
    MouseArea {
        anchors.fill: parent
        onClicked: Runtime.toggle("wifi")
    }
}
