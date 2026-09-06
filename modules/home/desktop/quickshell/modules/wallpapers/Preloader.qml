import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services

// A 1x1 window that exists solely to decode every wallpaper into Qt's
// texture cache, so the carousel is instant when it opens. Never seen.
PanelWindow {
    id: root

    // Must match Slide.qml exactly, or these become separate cache entries
    readonly property int decodeWidth: 380
    readonly property int decodeHeight: 440

    visible: true

    implicitWidth: 1
    implicitHeight: 1

    color: "transparent"

    anchors.top: true
    anchors.left: true

    WlrLayershell.layer: WlrLayershell.Background
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.namespace: "quickshell:wallpaper-precache"

    Item {
        width: 1
        height: 1

        clip: true

        Repeater {
            model: Wallpaper.images

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
