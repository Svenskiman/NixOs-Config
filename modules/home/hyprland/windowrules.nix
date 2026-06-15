{ lib, config, ... }:

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Window Rules --
            hl.window_rule({ match = { class = "floating" }, float = true })
        '';
    };
}