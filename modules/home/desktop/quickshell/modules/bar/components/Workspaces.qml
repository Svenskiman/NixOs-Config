import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.services

RowLayout {
    spacing: 8

    Repeater {
        model: 5

        Text {
            id: workspace
            required property int index
            property bool isActiveWorkspace: Hyprland.focusedWorkspace?.id === index + 1

            text: isActiveWorkspace ? "X" : index + 1
            color: isActiveWorkspace ? Theme.colors.accent : Theme.colors.color7
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16

            // Swap workspace on mouse click
            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspace.index + 1} })`)
            }
        }
    }
}
