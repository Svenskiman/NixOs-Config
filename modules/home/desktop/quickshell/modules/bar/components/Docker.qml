import QtQuick
import Quickshell
import qs.services

Text {
    text: ""

    color: {
        if (Docker.status === "running")
            return Theme.semantic.success;
        if (Docker.status === "idle")
            return Theme.colors.foreground;
        return Theme.semantic.error;
    }

    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["alacritty", "--class", "floating", "-e", "lazydocker"])
    }
}
