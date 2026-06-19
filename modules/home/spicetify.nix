{ lib, config, spicetify-nix, pkgs, ... }:

let
    nord = (builtins.head config.myModules.themes.definitions).colors;

    # Spicetify expects hex WITHOUT the leading '#'.
    strip = color: lib.removePrefix "#" color;
in

{
    options = {
        myModules.spicetify.enable = lib.mkEnableOption "Spicetify";
    };

    config = lib.mkIf config.myModules.spicetify.enable {
        programs.spicetify = {
            enable = true;

            customColorScheme = {
                text               = strip nord.foreground;
                subtext            = strip nord.foreground;
                main               = strip nord.background;
                sidebar            = strip nord.background;
                player             = strip nord.background;
                card               = strip nord.color0;
                shadow             = strip nord.background;
                selected-row       = strip nord.color8;
                button             = strip nord.accent;
                button-active      = strip nord.accent;
                button-disabled    = strip nord.color8;
                tab-active         = strip nord.accent;
                notification       = strip nord.accent;
                notification-error = strip nord.color1;
                misc               = strip nord.color8;
            };
        };
    };
}