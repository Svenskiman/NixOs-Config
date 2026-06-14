{ lib, config, ... }:

let
	terminal = "alacritty";
    system_monitor = "btop";
    file_manager = "nautilus --new-window";
    browser = "brave";
in

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Bindings --
            hl.bind("SUPER + Q", hl.dsp.exec_cmd("${terminal}"))
            hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("${file_manager}"))
            hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("${browser}"))
            hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("${browser} --incognito"))
            hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("${terminal} -e ${system_monitor}"))
            hl.bind("SUPER + W", hl.dsp.window.close())
            hl.bind("SUPER + Space", hl.dsp.exec_cmd("walker"))

            -- Workspaces
            for i = 1, 5 do
                hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
                hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
            end
        '';
    };
}
