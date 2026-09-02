import QtQuick
import qs.services

Rectangle {
    id: root

    property bool checked: false

    signal toggled(bool value)

    implicitWidth: 40
    implicitHeight: 22

    radius: height / 2

    color: root.checked ? Qt.alpha(Qt.color(Theme.colors.accent), 0.3) : Qt.alpha(Qt.color(Theme.colors.color7), 0.12)

    border.width: 1
    border.color: root.checked ? Theme.colors.accent : Theme.colors.color8

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }

    Rectangle {
        id: thumb

        width: parent.height - 8
        height: width
        radius: width / 2

        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 4 : 4

        color: root.checked ? Theme.colors.accent : Theme.colors.color7

        Behavior on x {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutQuad
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggled(!root.checked)
    }
}
