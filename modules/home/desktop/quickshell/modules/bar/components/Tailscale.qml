import QtQuick
import qs.services

Text {
    id: root

    readonly property bool panelOpen: Runtime.openPanel === "tailscale"

    text: "󰖂"

    color: root.panelOpen ? Theme.colors.accent : Theme.colors.foreground
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    MouseArea {
        anchors.fill: parent
        onClicked: Runtime.toggle("tailscale")
    }
}
