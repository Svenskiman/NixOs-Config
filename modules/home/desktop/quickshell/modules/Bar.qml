import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 40
    color: Theme.colors.background

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        // Left group
        RowLayout {
            spacing: 8

            Pill {
                Workspaces {}
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Right group
        RowLayout {
            spacing: 8

            Pill {
                Volume {}
            }
        }
    }

    // Centre group, anchored to the bar rather than the layout
    Pill {
        anchors.centerIn: parent

        Clock {}
    }
}
