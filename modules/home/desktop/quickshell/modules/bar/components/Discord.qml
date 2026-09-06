import QtQuick
import Quickshell
import qs.services

Text {
    text: ""

    color: {
        if (!Discord.running)
            return Theme.colors.color8;
        if (Discord.inCall)
            return Theme.semantic.success;
        return Theme.colors.foreground;
    }

    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["discord-toggle"])
    }
}
