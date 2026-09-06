import Quickshell.Io
import qs.services

// Lets Hyprland keybinds drive the shell
IpcHandler {
    target: "panel"

    function toggle(name: string): void {
        Runtime.toggle(name);
    }
}
