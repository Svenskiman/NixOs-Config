import QtQuick
import qs.services

Text {
    text: Mullvad.status === "disconnected" || Mullvad.status === "error" ? "󱦛" : "󰳌"

    color: {
        if (Mullvad.status === "connected")
            return Theme.semantic.success;
        if (Mullvad.status === "connecting")
            return Theme.colors.color3;
        if (Mullvad.status === "disconnected")
            return Theme.colors.color8;
        return Theme.semantic.error;
    }

    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    MouseArea {
        anchors.fill: parent
        onClicked: Mullvad.toggle()
    }
}
