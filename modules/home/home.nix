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
    ./btop.nix
  ];

  # Packages
  myModules.defaultApps.enable = true;
  myModules.defaultUtils.enable = true;

  # Scripts
  myModules.scripts.screenshot.enable = true;
  myModules.scripts.waybarMedia.enable = true;

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

  # Wallpaper via awww (swww)
  services.awww.enable = true;

  # TUIs
  myModules.btop.enable = true;


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
