{ lib, config, ... }:

{
  options = {
    myModules.direnv.enable = lib.mkEnableOption "direnv with nix-direnv";
  };

  config = lib.mkIf config.myModules.direnv.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
