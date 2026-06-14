{ lib, config, ... }:

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Autostart --
            hl.on("hyprland.start", function()
                hl.exec_cmd("waybar")
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("walker --gapplication-service")
                hl.exec_cmd("elephant")
            end)
        '';
    };
}