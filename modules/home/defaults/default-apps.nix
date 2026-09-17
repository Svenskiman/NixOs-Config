{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    myModules.defaultApps.enable = lib.mkEnableOption "Default apps";
  };

  config = lib.mkIf config.myModules.defaultApps.enable {
    home.packages = with pkgs; [

      # Terminals
      kitty # Hyprland's default

      # Browsers
      brave

      # Editors
      vim
      vscode
      gedit
      jetbrains-toolbox

      # Productivity
      obsidian

      # Media
      mpv
      blanket
      spotify

      # Disabled
      # foliate # E-reader
      # gnome-solanum # Timer
    ];
  };
}
