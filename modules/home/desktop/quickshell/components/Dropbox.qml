import QtQuick
import Quickshell
import qs.services

Text {
    text: ""

    color: {
        if (Dropbox.status === "synced")
            return Theme.colors.foreground;
        if (Dropbox.status === "syncing")
            return Theme.semantic.success;
        if (Dropbox.status === "paused")
            return Theme.colors.color3;
        return Theme.semantic.error;
    }

    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["dropbox-open"])
    }
}
