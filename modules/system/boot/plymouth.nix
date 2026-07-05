{ lib, config, ... }:

{
  options = {
    myModules.plymouth.enable = lib.mkEnableOption "Plymouth boot splash";
  };

  config = lib.mkIf config.myModules.plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "bgrt";
    };
    boot.kernelParams = [
      "quiet"
      "splash"
    ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
  };
}
