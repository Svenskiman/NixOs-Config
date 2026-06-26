{ lib, config, ... }:

{
    options = {
        myModules.btop.enable = lib.mkEnableOption "btop system monitor";
    };

    config = lib.mkIf config.myModules.btop.enable {
        programs.btop = {
            enable   = true;
            settings = {
                color_theme = "current";
                vim_keys = true;
            };
        };
    };
}