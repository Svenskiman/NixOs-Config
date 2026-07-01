{ lib, config, ... }:

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Window Rules --
            hl.window_rule({ match = { class = "floating" }, float = true })

            hl.window_rule({ match = { class = "imv" }, float = true })
            hl.window_rule({ match = { class = "imv" }, opacity = 1 })

            hl.window_rule({ match = { class = "org.gnome.Evince" }, float = true })
            hl.window_rule({ match = { class = "org.gnome.Evince" }, opacity = "1 override 1 override" })

            hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
            hl.window_rule({ match = { class = "org.gnome.Calculator" }, border_size = 0 })

            hl.window_rule({ match = { class = "steam" }, float = true })
            hl.window_rule({ match = { class = "steam" }, idle_inhibit = "fullscreen" })
            hl.window_rule({ match = { class = "steam" }, opacity = "1 1" })
            hl.window_rule({ match = { class = "steam", title = "^Steam$" }, size = "1100 700" })
            hl.window_rule({ match = { class = "steam", title = "^Steam$" }, center = true })
            hl.window_rule({ match = { class = "steam", title = "Friends List" }, size = "460 800" })
        '';
    };
}