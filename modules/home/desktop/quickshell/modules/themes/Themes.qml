import QtQuick
import qs.components
import qs.services

Carousel {
    id: root

    name: "themes"
    slideWidth: 260
    selectedWidth: 620
    slideHeight: 420
    lean: 0.1

    startIndex: ThemeList.currentIndex

    // "everforest" becomes "Everforest"
    items: ThemeList.names.map(name => ({
                image: ThemeList.preview(name),
                label: name.charAt(0).toUpperCase() + name.slice(1),
                value: name
            }))

    onAccepted: name => ThemeList.apply(name)
}
