{ lib, config, ... }:

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Window Rules --
            hl.window_rule({ match = { class = "floating" }, float = true })

            hl.window_rule({ match = { class = "imv" }, float = true })
            hl.window_rule({ match = { class = "imv" }, opacity = 1 })

            hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
            hl.window_rule({ match = { class = "org.gnome.Calculator" }, border_size = 0 })
        '';
    };
}