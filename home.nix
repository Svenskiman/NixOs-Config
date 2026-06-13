{ pkgs, config, ... }:

{
  imports = [
    ./modules/home/packages/packages-bundle.nix
  ];

  myModules.defaultApps.enable = true;
  myModules.defaultUtils.enable = true;

  home.username = "svenski";
  home.homeDirectory = "/home/svenski";
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };
}
