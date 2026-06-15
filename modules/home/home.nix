{ pkgs, config, ... }:

{
  imports = [
    ./packages/packages-bundle.nix
    ./hyprland/hyprland.nix
    ./terminal/terminal-bundle.nix
    ./xdg.nix
  ];

  # Packages modules
  myModules.defaultApps.enable = true;
  myModules.defaultUtils.enable = true;

  # Hyprland
  myModules.hypr.enable = true;

  # Terminal modules
  myModules.zsh.enable = true;
  myModules.alacritty.enable = true;

  # Default directories
  myModules.xdg.enable = true;
  

  home.username = "svenski";
  home.homeDirectory = "/home/svenski";
  home.stateVersion = "26.05";

  # Lauch Hyprland on login
  programs.bash = {
    enable = true;
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };
}
