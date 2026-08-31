import QtQuick
import qs.services

Item {
    id: root

    property real value: 0

    // Emitted while dragging and on click
    signal moved(real value)

    implicitHeight: 16

    // Track
    Rectangle {
        id: track

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        height: 4
        radius: 2
        color: Theme.colors.color8
    }

    // Filled portion, width follows the value
    Rectangle {
        anchors.left: track.left
        anchors.verticalCenter: track.verticalCenter

        width: track.width * root.value
        height: 4
        radius: 2
        color: Theme.colors.accent
    }

    // Marker at the current position
    Rectangle {
        anchors.verticalCenter: track.verticalCenter

        x: track.width * root.value - width / 2
        width: 3
        height: 14
        radius: 1
        color: Theme.colors.accent
    }

    // Click or drag anywhere on the track to set the value
    MouseArea {
        anchors.fill: parent

        onPressed: mouse => root.moved(Math.max(0, Math.min(1, mouse.x / width)))
        onPositionChanged: mouse => root.moved(Math.max(0, Math.min(1, mouse.x / width)))
    }
}
