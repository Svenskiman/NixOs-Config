{ lib, config, ... }:

{
    options = {
        myModules.hypr.singleWindowAspectRatio = lib.mkOption {
            type = lib.types.str;
            default = "0 0";
            description = "Aspect ratio for lone windows";
        };

        myModules.hypr.singleWindowAspectRatioTolerance = lib.mkOption {
            type = lib.types.float;
            default = 0.1;
            description = "Tolerance for singleWindowAspectRatio.";
        };
    };

    config = {
        wayland.windowManager.hyprland.extraConfig = ''
            -- Look and Feel --
            -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/

            -- Load active theme colours into hl.config
            dofile(os.getenv("HOME") .. "/.local/state/theme/current/hyprland-colours.lua")

            hl.config({
                general = {
                    gaps_in          = 5,
                    gaps_out         = 10,
                    border_size      = 2,
                    resize_on_border = false,
                    allow_tearing    = false,
                    layout           = "dwindle",
                },

                decoration = {
                    rounding = 8,
                    shadow = {
                        enabled      = true,
                        range        = 2,
                        render_power = 3,
                        color        = "rgba(1a1a1aee)",
                    },
                    blur = {
                        enabled    = true,
                        size       = 2,
                        passes     = 2,
                        special    = true,
                        brightness = 0.60,
                        contrast   = 0.75,
                    },
                },

                xwayland = {
                    force_zero_scaling = true,
                },

                animations = {
                    enabled = true,
                },

                group = {
                    groupbar = {
                        font_size            = 12,
                        font_family          = "monospace",
                        font_weight_active   = "ultraheavy",
                        font_weight_inactive = "normal",
                        indicator_height     = 0,
                        indicator_gap        = 5,
                        height               = 22,
                        gaps_in              = 5,
                        gaps_out             = 0,
                        text_color           = "rgb(ffffff)",
                        text_color_inactive  = "rgba(ffffff90)",
                        col = {
                            active   = "rgba(00000040)",
                            inactive = "rgba(00000020)",
                        },
                        gradients                 = true,
                        gradient_rounding         = 0,
                        gradient_round_only_edges = false,
                    },
                },

                dwindle = {
                    force_split    = 2,
                    preserve_split = true,
                },

                layout = {
                    single_window_aspect_ratio = "${config.myModules.hypr.singleWindowAspectRatio}",
                    single_window_aspect_ratio_tolerance = ${toString config.myModules.hypr.singleWindowAspectRatioTolerance},
                },

                misc = {
                    disable_hyprland_logo      = true,
                    disable_splash_rendering   = true,
                    disable_scale_notification = true,
                    focus_on_activate          = true,
                    anr_missed_pings           = 3,
                    on_focus_under_fullscreen  = 1,
                },

                cursor = {
                    hide_on_key_press        = true,
                    warp_on_change_workspace = 1,
                },

                binds = {
                    hide_special_on_workspace_change = true,
                },
            })

            -- Curves --
            hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}   } })
            hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}   } })
            hl.curve("linear",         { type = "bezier", points = { {0,    0},    {1,    1}   } })
            hl.curve("almostLinear",   { type = "bezier", points = { {0.5,  0.5},  {0.75, 1.0} } })
            hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1,  1}   } })

            -- Animations --
            hl.animation({ leaf = "border",           enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
            hl.animation({ leaf = "windows",          enabled = true,  speed = 3.79, bezier = "easeOutQuint" })
            hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
            hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
            hl.animation({ leaf = "fadeIn",           enabled = true,  speed = 1.73, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeOut",          enabled = true,  speed = 1.46, bezier = "almostLinear" })
            hl.animation({ leaf = "fade",             enabled = true,  speed = 3.03, bezier = "quick"        })
            hl.animation({ leaf = "layers",           enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
            hl.animation({ leaf = "layersIn",         enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
            hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
            hl.animation({ leaf = "fadeLayersIn",     enabled = true,  speed = 1.79, bezier = "almostLinear" })
            hl.animation({ leaf = "fadeLayersOut",    enabled = true,  speed = 1.39, bezier = "almostLinear" })
            hl.animation({ leaf = "workspaces",       enabled = false })
            hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 3,    bezier = "easeOutQuint", style = "slidevert" })
        '';
    };
}
