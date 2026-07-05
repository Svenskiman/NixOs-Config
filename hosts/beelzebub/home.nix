{ pkgs, config, ... }:

{
  imports = [
    ./../../modules/home/default.nix
  ];

  # Core
  home.username = "svenski";
  home.homeDirectory = "/home/svenski";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  # Monitors
  myModules.hypr.monitors = [
    {
      output = "eDP-1";
      mode = "preferred";
      position = "auto";
      scale = 2.0;
    }
  ];

  # Applications (configured)
  myModules.applications.enable = true;

  # Config
  myModules.isLaptop = true;
  myModules.xdg.enable = true;
  myModules.zsh.enable = true;

  # Defaults (not configured)
  myModules.defaultApps.enable = true;
  myModules.defaultUtils.enable = true;

  # Desktop environment
  myModules.desktop.enable = true;
  myModules.waybar.enable = false; # Override as we use EWW instead

  # Dev environment
  myModules.direnv.enable = true;

  # Patches
  myModules.audioFixes.zenbookMicBoost.enable = true;

  # Scripts
  myModules.scripts.screenshot.enable = true;

  # Services
  myModules.services.enable = true;

  # Clamshell
  myModules.clamshell.enable = false;

  # Uncomment if not using SDDM
  # programs.bash = {
  #     enable = true;
  #     profileExtra = ''
  #         if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  #             exec start-hyprland
  #         fi
  #     '';
  # };
}
