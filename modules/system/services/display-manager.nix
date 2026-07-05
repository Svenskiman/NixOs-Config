{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    myModules.displayManager.sddm.enable = lib.mkEnableOption "SDDM display manager with SilentSDDM theme";
  };

  config = lib.mkIf config.myModules.displayManager.sddm.enable {
    programs.silentSDDM = {
      enable = true;
      theme = "everforest";

      settings = {
        LockScreen = {
          background = "smoky.jpg";
          use-background-color = false;
        };
        LoginScreen = {
          background = "smoky.jpg";
          use-background-color = false;
        };
      };
    };

    services.displayManager.sddm.wayland.enable = true;
  };
}
