{ lib, config, ... }:

{
  options = {
    myModules.hyprlock.enable = lib.mkEnableOption "Hyprlock PAM service";
  };

  config = lib.mkIf config.myModules.hyprlock.enable {
    security.pam.services.hyprlock = { };
  };
}
