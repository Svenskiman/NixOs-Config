//@ pragma ShellId nixshell

import Quickshell
import QtQuick

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 40
        color: "#282828"

        Text {
            anchors.centerIn: parent
            text: "text"
            color: "#e2cca9"
            font.pixelSize: 16
        }
    }
}
