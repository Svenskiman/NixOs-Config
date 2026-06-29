{ lib, config, ... }:

{
    options = {
        myModules.hyprlock.enable = lib.mkEnableOption "Hyprlock screen locker";
    };

    config = lib.mkIf config.myModules.hyprlock.enable {
        programs.hyprlock = {
            enable = true;

            settings = {
                source = [ "/home/svenski/.local/state/theme/current/hyprlock.conf" ];

                general = {
                    ignore_empty_input = true;
                    hide_cursor = true;
                };

                background = [{
                    monitor = "";
                    path = "screenshot";
                    blur_passes = 3;
                    blur_size = 6;
                    brightness = 0.6;
                }];

                input-field = [{
                    monitor = "";
                    # Width, Height
                    size = "800, 120";
                    # X, Y
                    position = "0, 0";
                    halign = "center";
                    valign = "center";

                    font_family = "JetBrainsMono Nerd Font";
                    font_size = 18;

                    inner_color = "$inner_color";
                    outer_color = "$outer_color";
                    font_color = "$font_color";
                    check_color = "$check_color";
                    fail_color = "$fail_color";

                    placeholder_text = "Enter password";
                    fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
                    fade_on_empty = false;

                    rounding = 8;
                    outline_thickness = 2;
                    shadow_passes = 0;
                }];
            };
        };
    };
}