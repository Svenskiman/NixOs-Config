import QtQuick
import qs.services

Item {
    id: root

    property bool altFormat: false

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    Text {
        id: label

        anchors.centerIn: parent

        text: root.altFormat ? Time.long : Time.short
        color: "#e2cca9"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
        font.weight: Font.Medium
    }

    // Toggle between time and full date on mouse click
    MouseArea {
        anchors.fill: parent
        onClicked: root.altFormat = !root.altFormat
    }
}
