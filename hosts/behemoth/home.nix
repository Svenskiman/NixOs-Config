{ pkgs, ... }:

{
  imports = [
    ./../../modules/home/default.nix
  ];

  home = {
    username = "svenski";
    homeDirectory = "/home/svenski";
    stateVersion = "26.05";
    sessionVariables = {
      GTK_THEME = "adw-gtk3-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  myModules = {

    # Host specific Hyprland settings
    hypr = {
      singleWindowAspectRatio = "18 16";
      sensitivity = -0.50;
      workspaceMonitors = [
        {
          id = 1;
          monitor = "DP-3";
        }
        {
          id = 2;
          monitor = "DP-1";
        }
        {
          id = 3;
          monitor = "DP-1";
        }
        {
          id = 4;
          monitor = "DP-1";
        }
        {
          id = 5;
          monitor = "DP-2";
        }
      ];
      monitors = [
        {
          output = "DP-1";
          mode = "3840x2160@240.02";
          position = "1440x560";
          scale = 1.5;
          bitdepth = 10;
        }
        {
          output = "DP-2";
          mode = "2560x1440@143.97";
          position = "4000x0";
          scale = 1.0;
          transform = 1;
        }
        {
          output = "DP-3";
          mode = "2560x1440@143.97";
          position = "0x0";
          scale = 1.0;
          transform = 3;
        }
      ];
    };

    # Applications (configured)
    applications.enable = true;

    # Config
    xdg.enable = true;
    zsh.enable = true;

    # Defaults (not configured)
    defaultApps.enable = true;
    defaultUtils.enable = true;

    # Desktop environment
    desktop.enable = true;
    waybar.enable = false;

    # Dev environment
    direnv.enable = true;
    neovim.enable = true;
    opencode.enable = true;

    # Games
    prismlauncher.enable = true;

    # Scripts
    scripts = {
      screenshot.enable = true;
      aiLocal.enable = true;
    };

    # Services
    services.enable = true;
  };
}
