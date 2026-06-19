{ lib, config, pkgs, ... }:

{
    options = {
        myModules.eww.enable = lib.mkEnableOption "Eww";
    };

    config = lib.mkIf config.myModules.eww.enable {

        xdg.configFile = {
            "eww/eww.yuck".source = ./bar.yuck;
            "eww/eww.css".source  = ./style.scss;
        };
    };
}