{ lib, config, ... }:

{
    options = {
        myModules.mako.enable = lib.mkEnableOption "mako notifications";
    };

    config = lib.mkIf config.myModules.mako.enable {
        services.mako = {
            enable = true;
            settings = {
                default-timeout = 2000;
            };
        };
    };
}