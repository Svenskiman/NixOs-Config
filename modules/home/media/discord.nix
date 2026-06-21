{ lib, config, pkgs, ... }:

{
    options.myModules.discord.enable = lib.mkEnableOption "Discord";

    config = lib.mkIf config.myModules.discord.enable {
        home.packages = [ pkgs.discord ];
    };
}