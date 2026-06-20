{ lib, config, pkgs, ... }:

{
    options.myModules.dropbox.enable = lib.mkEnableOption "Dropbox sync";

    config = lib.mkIf config.myModules.dropbox.enable {
        services.dropbox.enable = true;
    };
}