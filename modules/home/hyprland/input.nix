{ lib, config, ... }:

{
    config = {
        wayland.windowManager.hyprland.extraConfig = ''

            -- Input --
            hl.config({
                input = {
                    kb_layout          = "gb",
                    kb_options         = "compose:caps",

                    repeat_rate        = 40,
                    repeat_delay       = 600,

                    numlock_by_default = true,

                    sensitivity        = -0.05,
                    force_no_accel     = false,
                    follow_mouse       = 1,

                    touchpad = {
                        natural_scroll = false,
                        clickfinger_behavior = true,
                        scroll_factor  = 0.4,
                    },
                },

                misc = {
                    key_press_enables_dpms  = true,
                    mouse_move_enables_dpms = true,
                },

                cursor = {
                    no_hardware_cursors = true,
                },
            })

            hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
        '';
    };
}