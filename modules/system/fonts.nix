{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    myModules.fonts.enable = lib.mkEnableOption "System fonts";
  };

  config = lib.mkIf config.myModules.fonts.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
