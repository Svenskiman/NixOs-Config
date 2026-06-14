{ pkgs, config, ... }:

{
  imports = [
    ./packages/packages-bundle.nix
    ./hyprland/hyprland.nix
    ./xdg.nix
  ];

  myModules.defaultApps.enable = true;
  myModules.defaultUtils.enable = true;
  myModules.hypr.enable = true;
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
