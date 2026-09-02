import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root

    default property alias content: layout.data

    implicitWidth: layout.implicitWidth + 28
    implicitHeight: 28

    radius: height / 2
    color: Theme.colors.background

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 16
    }
}
