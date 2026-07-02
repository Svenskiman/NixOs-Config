{ lib, config, pkgs, ... }:

{
    options = {
        myModules.eww.enable = lib.mkEnableOption "Eww";
    };

    config = lib.mkIf config.myModules.eww.enable {

        home.packages = [ pkgs.eww ];

        xdg.configFile = {
            "eww/bar.yuck".source = ./bar/bar.yuck;
            "eww/dropdown.yuck".source = ./dropdown/dropdown.yuck;

            # Merge bar and dropdown configurations
            "eww/eww.yuck".text = ''
                (include "./bar.yuck")
                (include "./dropdown.yuck")
            '';

            "eww/nixos-logo.svg".source = ../../../../assets/icons/NixOS.svg;
            "eww/behemoth.png".source = ../../../../assets/icons/behemoth.png;

            "eww/eww.css".text =
                ''
                    @import "${config.home.homeDirectory}/.local/state/theme/current/eww.css";
                ''
                + builtins.readFile ./bar/style.css
                + builtins.readFile ./dropdown/style.css;
        };
    };
}