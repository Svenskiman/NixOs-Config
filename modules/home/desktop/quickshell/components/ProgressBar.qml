import QtQuick
import qs.services

Item {
    id: root

    // 0.0 to 1.0
    property real value: 0

    // Greyed out when the underlying stat isn't available
    property bool available: true

    implicitHeight: 5

    // Track
    Rectangle {
        id: track

        anchors.fill: parent

        radius: height / 2
        color: Qt.alpha(Qt.color(Theme.colors.foreground), 0.1)
    }

    // Fill, colour steps with the value
    Rectangle {
        anchors.left: track.left
        anchors.verticalCenter: track.verticalCenter

        width: track.width * (root.available ? Math.max(0, Math.min(1, root.value)) : 0)
        height: track.height
        radius: height / 2

        color: {
            if (!root.available)
                return Theme.colors.color8;
            if (root.value >= 0.8)
                return Theme.semantic.error;
            if (root.value >= 0.5)
                return Theme.colors.color3;
            return Theme.semantic.success;
        }
    }
}
