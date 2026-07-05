{ lib, config, ... }:

{
  options = {
    myModules.wallpaper.enable = lib.mkEnableOption "Wallpaper daemon (awww)";
  };

  config = lib.mkIf config.myModules.wallpaper.enable {
    services.awww.enable = true;
  };
}
