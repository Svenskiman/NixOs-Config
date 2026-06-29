{ lib, config, ... }:

let
    # ── Schema ────────────────────────────────────────────────────────────────
    colorType = lib.types.submodule {
        options = {
            background           = lib.mkOption { type = lib.types.str; };
            foreground           = lib.mkOption { type = lib.types.str; };
            cursor               = lib.mkOption { type = lib.types.str; };
            accent               = lib.mkOption { type = lib.types.str; };
            selection_background = lib.mkOption { type = lib.types.str; };
            selection_foreground = lib.mkOption { type = lib.types.str; };

            color0  = lib.mkOption { type = lib.types.str; };
            color1  = lib.mkOption { type = lib.types.str; };
            color2  = lib.mkOption { type = lib.types.str; };
            color3  = lib.mkOption { type = lib.types.str; };
            color4  = lib.mkOption { type = lib.types.str; };
            color5  = lib.mkOption { type = lib.types.str; };
            color6  = lib.mkOption { type = lib.types.str; };
            color7  = lib.mkOption { type = lib.types.str; };
            color8  = lib.mkOption { type = lib.types.str; };
            color9  = lib.mkOption { type = lib.types.str; };
            color10 = lib.mkOption { type = lib.types.str; };
            color11 = lib.mkOption { type = lib.types.str; };
            color12 = lib.mkOption { type = lib.types.str; };
            color13 = lib.mkOption { type = lib.types.str; };
            color14 = lib.mkOption { type = lib.types.str; };
            color15 = lib.mkOption { type = lib.types.str; };
        };
    };

    # VS Code theme metadata — extension to install and theme name to set.
    # settings holds any extra keys to merge into settings.json (e.g. everforest.contrast).
    vscodeType = lib.types.submodule {
        options = {
            name      = lib.mkOption { type = lib.types.str; };
            extension = lib.mkOption { type = lib.types.str; };
            settings  = lib.mkOption {
                type    = lib.types.attrsOf lib.types.str;
                default = {};
            };
        };
    };

    themeType = lib.types.submodule {
        options = {
            name        = lib.mkOption { type = lib.types.str; };
            displayName = lib.mkOption { type = lib.types.str; };
            iconTheme   = lib.mkOption { type = lib.types.str; default = "Yaru-blue"; };
            colors      = lib.mkOption { type = colorType; };
            vscode      = lib.mkOption { type = lib.types.nullOr vscodeType; default = null; };
        };
    };
in

{
    imports = [
        ./first-boot.nix
        ./targets/eww-colours.nix
        ./targets/waybar-colours.nix
        ./targets/hyprland-colours.nix
        ./targets/mako-colours.nix
        ./targets/walker-colours.nix
        ./targets/alacritty-colours.nix
        ./targets/btop-colours.nix
        ./targets/swayosd-colours.nix
        ./targets/vscode-colours.nix
        ./targets/hyprlock-colours.nix
    ];

    options = {
        myModules.themes.definitions = lib.mkOption {
            type    = lib.types.listOf themeType;
            default = [
                (import ./definitions/nord.nix)
                (import ./definitions/gruvbox.nix)
                (import ./definitions/everforest.nix)
                (import ./definitions/silent-hill.nix)
            ];
        };
    };

    config = {};
}