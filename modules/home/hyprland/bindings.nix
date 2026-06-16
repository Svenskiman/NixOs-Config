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
            hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("${terminal} --class floating -e ${system_monitor}"))
            hl.bind("SUPER + W", hl.dsp.window.close())
            hl.bind("SUPER + Space", hl.dsp.exec_cmd("walker"))
            hl.bind("SUPER + SHIFT + grave", hl.dsp.exec_cmd("capture-screenshot"))
            hl.bind("SUPER + CTRL + grave",  hl.dsp.exec_cmd("capture-screenshot-annotate"))

            -- Workspaces
            for i = 1, 5 do
                hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
                hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
            end

            -- Window management
            hl.bind("SUPER + F", hl.dsp.window.fullscreen())
            hl.bind("SUPER + T", hl.dsp.window.float())
            hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
            hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })  
            hl.bind("SUPER + CTRL + LEFT",  hl.dsp.window.swap({ direction = "left" }))
            hl.bind("SUPER + CTRL + RIGHT", hl.dsp.window.swap({ direction = "right" }))
            hl.bind("SUPER + CTRL + UP",    hl.dsp.window.swap({ direction = "up" }))
            hl.bind("SUPER + CTRL + DOWN",  hl.dsp.window.swap({ direction = "down" }))

            -- Groups
            hl.bind("SUPER + G",           hl.dsp.group.toggle())
            hl.bind("SUPER + ALT + G",     hl.dsp.window.move({ out_of_group = true }))
            hl.bind("SUPER + ALT + LEFT",  hl.dsp.group.prev())
            hl.bind("SUPER + ALT + RIGHT", hl.dsp.group.next())
        '';
    };
}
