{ lib, config, ... }:

let
    # ── Schema ────────────────────────────────────────────────────────────────
    # Required colour keys every theme must provide.
    # Missing any of these fails the build at eval time.
    colorType = lib.types.submodule {
        options = {
            background           = lib.mkOption { type = lib.types.str; };
            foreground           = lib.mkOption { type = lib.types.str; };
            cursor               = lib.mkOption { type = lib.types.str; };
            accent               = lib.mkOption { type = lib.types.str; };
            selection_background = lib.mkOption { type = lib.types.str; };
            selection_foreground = lib.mkOption { type = lib.types.str; };

            # Standard 16-colour ANSI terminal palette
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

    # A complete theme — name, display name, iconTheme, and a validated colour set
    themeType = lib.types.submodule {
        options = {
            name        = lib.mkOption { type = lib.types.str; };
            displayName = lib.mkOption { type = lib.types.str; };
            iconTheme   = lib.mkOption { type = lib.types.str; default = "Yaru-blue"; };
            colors      = lib.mkOption { type = colorType; };
        };
    };
in

{
    # Import target files — each one reads definitions and writes
    # per-theme config files into ~/.config/themes/<name>/
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
    ];

    options = {
        # List of all available themes, each validated against themeType.
        # Nord is always present by default.
        # To add a theme: append (import ./definitions/mytheme.nix) to this list.
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