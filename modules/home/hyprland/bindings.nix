{ lib, config, ... }:

let
	terminal = "alacritty";
    file_manager = "nautilus";
in

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Bindings --
            hl.bind("SUPER + Q", hl.dsp.exec_cmd("${terminal}"))
            hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("${file_manager}"))
            hl.bind("SUPER + W", hl.dsp.window.close())
            hl.bind("SUPER + Space", hl.dsp.exec_cmd("walker"))
        '';
    };
}
