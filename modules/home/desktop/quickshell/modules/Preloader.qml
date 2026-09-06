import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services

// A 1x1 window that exists solely to decode every carousel image into Qt's
// texture cache, so the carousels are instant when they open. Never seen.
PanelWindow {
    id: root

    // Must match CarouselSlide.qml exactly, or these become separate entries
    readonly property int decodeWidth: 380
    readonly property int decodeHeight: 440

    readonly property var paths: Wallpaper.images.concat(ThemeList.names.map(name => ThemeList.preview(name)))

    visible: true

    implicitWidth: 1
    implicitHeight: 1

    color: "transparent"

    anchors.top: true
    anchors.left: true

    WlrLayershell.layer: WlrLayershell.Background
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:carousel-precache"

    Item {
        width: 1
        height: 1

        clip: true

        Repeater {
            model: root.paths

            Image {
                required property string modelData

                width: root.decodeWidth
                height: root.decodeHeight

                source: `file://${modelData}`

                asynchronous: true
                cache: true

                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(root.decodeWidth, root.decodeHeight)
            }
        }
    }
}
