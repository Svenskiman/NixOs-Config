{ pkgs, config, ... }:

{
  imports = [
    ./packages/packages-bundle.nix
    ./scripts/scripts-bundle.nix
    ./terminal/terminal-bundle.nix
    ./themes/themes.nix
    ./hyprland/hyprland.nix
    ./waybar/waybar.nix
    ./walker/walker.nix
    ./xdg.nix
  ];

  # Packages
  myModules.defaultApps.enable = true;
  myModules.defaultUtils.enable = true;

  # Scripts
  myModules.scripts.screenshot.enable = true;

  # Terminal modules
  myModules.zsh.enable = true;
  myModules.alacritty.enable = true;

  # Hyprland
  myModules.hypr.enable = true;

  # Default directories
  myModules.xdg.enable = true;

  # Waybar
  myModules.waybar.enable = true;

  # Walker
  myModules.walker.enable = true;

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
