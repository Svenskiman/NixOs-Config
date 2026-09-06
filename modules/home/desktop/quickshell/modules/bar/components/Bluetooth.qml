import QtQuick
import qs.services

Text {
    id: root

    readonly property bool panelOpen: Runtime.openPanel === "bluetooth"

    text: {
        if (!Bluetooth.enabled)
            return "󰂲";
        if (Bluetooth.connected.length > 0)
            return "󰂱";
        return "󰂯";
    }

    color: root.panelOpen ? Theme.colors.accent : Theme.colors.foreground
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    // Click opens the bluetooth panel
    MouseArea {
        anchors.fill: parent
        onClicked: Runtime.toggle("bluetooth")
    }
}
