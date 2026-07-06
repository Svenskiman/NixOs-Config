{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.lmstudio.enable = lib.mkEnableOption "LM Studio server";
  };

  config = lib.mkIf config.myModules.lmstudio.enable {

    # Required for LM Studio's bundled ROCm runtime to detect AMD GPU
    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];

    services.lmstudio = {
      enable = true;
      port = 1234;
      dataDir = "/var/lib/lmstudio";
    };
  };
}
