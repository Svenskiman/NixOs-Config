{ lib, config, pkgs, ... }:

{
    options = {
        myModules.eww.enable = lib.mkEnableOption "Eww";
    };

    config = lib.mkIf config.myModules.eww.enable {

        home.packages = [ pkgs.eww ];

        xdg.configFile = {
            "eww/eww.yuck".source = ./bar.yuck;
            "eww/eww.scss".source = ./style.scss;
        };
    };
}