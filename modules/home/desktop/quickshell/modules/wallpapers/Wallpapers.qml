import QtQuick
import qs.components
import qs.services

Carousel {
    id: root

    name: "wallpapers"

    startIndex: Wallpaper.currentIndex

    // "1-misty-forest.png" becomes "Misty Forest"
    items: Wallpaper.images.map(path => {
        const file = path.split("/").pop();
        const bare = file.replace(/\.[^.]+$/, "").replace(/^\d+-/, "");

        return {
            image: path,
            label: bare.split("-").map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(" "),
            value: path
        };
    })

    onIsOpenChanged: if (root.isOpen)
        Wallpaper.refresh()

    onAccepted: path => Wallpaper.apply(path)
}
