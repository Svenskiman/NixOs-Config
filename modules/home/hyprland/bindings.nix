{ lib, config, ... }:

let
	terminal = "alacritty";
in

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''
            hl.bind("SUPER + Q", hl.dsp.exec_cmd("${terminal}"))
            hl.bind("SUPER + W", hl.dsp.window.close())
            hl.bind("SUPER + Space", hl.dsp.exec_cmd("walker"))
        '';
    };
}
