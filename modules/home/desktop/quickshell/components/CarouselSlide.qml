import QtQuick

Item {
    id: root

    required property string path
    required property bool selected

    opacity: root.selected ? 1 : 0.75

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    Image {
        anchors.fill: parent

        // Empty until the list loads, and file:/// is a directory
        source: root.path === "" ? "" : `file://${root.path}`

        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true

        // Identical for every slot, so the preloaded texture is reused
        // whether the slide is narrow or the wide centre one
        sourceSize.width: 380
        sourceSize.height: root.height
    }
}
