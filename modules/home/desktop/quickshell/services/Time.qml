pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string short: Qt.formatDateTime(clock.date, "dddd HH:mm")

    readonly property string long: Qt.formatDateTime(clock.date, "dd MMMM") + " W" + isoWeek(clock.date) + " " + Qt.formatDateTime(clock.date, "yyyy")

    function isoWeek(date) {
        const thursday = new Date(date);
        thursday.setHours(0, 0, 0, 0);
        thursday.setDate(thursday.getDate() + 3 - (thursday.getDay() + 6) % 7);

        const jan4 = new Date(thursday.getFullYear(), 0, 4);
        return 1 + Math.round((thursday - jan4) / 604800000);
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
