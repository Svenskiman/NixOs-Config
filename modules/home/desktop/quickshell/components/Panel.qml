import Quickshell
import QtQuick
import qs.services

PanelWindow {
    id: root

    required property string name

    // "topRight" or "centre"
    property string position: "topRight"

    property int panelWidth: 420

    // 0 means size to content
    property int panelHeight: 0

    default property alias content: container.data

    visible: Runtime.openPanel === root.name

    // Covers the screen so clicks outside the panel can be caught
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    color: "transparent"

    // Floats over windows rather than reserving space
    exclusionMode: ExclusionMode.Ignore

    // Clicking anywhere outside the panel closes it
    MouseArea {
        anchors.fill: parent
        onClicked: Runtime.openPanel = ""
    }

    // The visible panel box
    Rectangle {
        anchors.top: root.position === "topRight" ? parent.top : undefined
        anchors.right: root.position === "topRight" ? parent.right : undefined
        anchors.centerIn: root.position === "centre" ? parent : undefined

        anchors.topMargin: 48
        anchors.rightMargin: 8

        implicitWidth: root.panelWidth
        implicitHeight: root.panelHeight > 0 ? root.panelHeight : container.implicitHeight + 32

        radius: 12
        color: Theme.colors.background
        border.width: 1
        border.color: Theme.colors.color8

        // Swallows clicks so they don't reach the closing MouseArea
        MouseArea {
            anchors.fill: parent
        }

        // Column sizes itself to its children
        Column {
            id: container

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 16

            spacing: 12
        }
    }
}
