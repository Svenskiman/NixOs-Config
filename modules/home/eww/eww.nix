{ lib, config, pkgs, ... }:

{
    options = {
        myModules.eww.enable = lib.mkEnableOption "Eww";
    };

    config = lib.mkIf config.myModules.eww.enable {

        xdg.configFile = {
            "eww/eww.yuck".source = ./bar.yuck;

            "eww/eww.css".text =
                ''
                    @import "/home/svenski/.local/state/theme/current/eww.css";
                ''
                + builtins.readFile ./style.css;
        };
    };
}