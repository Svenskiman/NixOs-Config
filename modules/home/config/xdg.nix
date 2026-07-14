{ lib, config, ... }:

let
  # Template for overridden and custom entries
  makeEntry = app: {
    name = "applications/${app.file}.desktop";
    value = {
      text = ''
        [Desktop Entry]
        Type=Application
        Name=${app.name}
        Icon=${app.icon}
        Exec=${app.exec}
        Terminal=false
      '';
    };
  };

  # Desktop entries to hide from Walker entirely
  hiddenApps = [
    "btop"
    "dropbox"
    "org.gnome.Nautilus"
    "gvim"
    "vim"
    "uuctl"
  ];

  # Override existing desktop entries with a custom name, icon and exec.
  # Find correct values with:
  # cat /etc/profiles/per-user/<user>/share/applications/<name>.desktop
  overriddenApps = [
    {
      file = "mpv";
      name = "Media Player";
      icon = "mpv";
      exec = "mpv --player-operation-mode=pseudo-gui -- %U";
    }
    {
      file = "kitty";
      name = "Kitty";
      icon = "kitty";
      exec = "kitty";
    }
    {
      file = "nvim";
      name = "Neovim";
      icon = "nvim";
      exec = "alacritty -e nvim";
    }
    {
      file = "org.gnome.gedit";
      name = "Gedit";
      icon = "org.gnome.gedit";
      exec = "gedit";
    }

  ];

  # Custom desktop entries with no corresponding system entry.
  customApps = [
    {
      file = "nixconf-settings";
      name = "Settings";
      icon = "preferences-system";
      exec = "code ${config.home.homeDirectory}/.config/nixconf";
    }
  ];
in

{
  options = {
    myModules.xdg = {
      enable = lib.mkEnableOption "XDG configuration";
      user.enable = lib.mkEnableOption "XDG user directories";
      desktop.enable = lib.mkEnableOption "XDG desktop entries";
      server.enable = lib.mkEnableOption "Server directories";
    };
  };

  config = lib.mkMerge [

    # xdg.enable sets both sub-options
    (lib.mkIf config.myModules.xdg.enable {
      myModules.xdg.user.enable = lib.mkDefault true;
      myModules.xdg.desktop.enable = lib.mkDefault true;
    })

    # User directories
    (lib.mkIf config.myModules.xdg.user.enable {

      # Create core user home directories
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        publicShare = "${config.home.homeDirectory}/Public";
        templates = "${config.home.homeDirectory}/Templates";
        videos = "${config.home.homeDirectory}/Videos";
      };

      # Create subdirectories
      home.file = {
        "Pictures/Wallpapers/.keep".text = "";
        "Pictures/Screenshots/.keep".text = "";
        "Documents/University/.keep".text = "";
        "Documents/Work/.keep".text = "";
        "Documents/Personal/.keep".text = "";
      };
    })

    # Server directories
    (lib.mkIf config.myModules.xdg.server.enable {
      home.file = {
        "Servers/.keep".text = "";
        "Media/.keep".text = "";
        "Backups/.keep".text = "";
      };
    })

    # Desktop entry overrides — only active when walker is enabled
    (lib.mkIf (config.myModules.xdg.desktop.enable && config.myModules.walker.enable) {
      xdg.dataFile =
        lib.listToAttrs (
          map (app: {
            name = "applications/${app}.desktop";
            value = {
              text = "[Desktop Entry]\nNoDisplay=true\n";
            };
          }) hiddenApps
        )
        // lib.listToAttrs (map makeEntry overriddenApps)
        // lib.listToAttrs (map makeEntry customApps);
    })
  ];
}
