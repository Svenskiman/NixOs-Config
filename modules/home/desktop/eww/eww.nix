{ lib, config, pkgs, ... }:

{
    options = {
        myModules.eww.enable = lib.mkEnableOption "Eww";
    };

    config = lib.mkIf config.myModules.eww.enable {

        home.packages = [ pkgs.eww ];

        xdg.configFile = {
            "eww/eww.yuck".source = ./bar.yuck;
            "eww/nixos-logo.svg".source = ../../../../assets/icons/NixOS.svg;

            "eww/eww.css".text =
                ''
                    @import "/home/svenski/.local/state/theme/current/eww.css";
                ''
                + builtins.readFile ./style.css;
        };
    };
}