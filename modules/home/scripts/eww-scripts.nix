{ pkgs, lib, config, ... }:

let
in

{
    options = {
        myModules.scripts.eww.enable = lib.mkEnableOption "Eww scripts";
    };

    config = lib.mkIf config.myModules.scripts.eww.enable {
        home.packages = [
        ];
    };
}