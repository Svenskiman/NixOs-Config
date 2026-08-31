import Quickshell
import QtQuick
import qs.components

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: "#282828"

    Workspaces {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Clock {
        anchors.centerIn: parent
    }
}
