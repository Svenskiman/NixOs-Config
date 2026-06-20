{ lib, config, ... }:

{
  options = {
    myModules.xdg.enable = lib.mkEnableOption "XDG user directories";
  };

  config = lib.mkIf config.myModules.xdg.enable {

    # Create core user home directories
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop     = "${config.home.homeDirectory}/Desktop";
      documents   = "${config.home.homeDirectory}/Documents";
      download    = "${config.home.homeDirectory}/Downloads";
      music       = "${config.home.homeDirectory}/Music";
      pictures    = "${config.home.homeDirectory}/Pictures";
      publicShare = "${config.home.homeDirectory}/Public";
      templates   = "${config.home.homeDirectory}/Templates";
      videos      = "${config.home.homeDirectory}/Videos";
    };

    # Create subdirectories
    home.file = {
      "Pictures/Wallpapers/.keep".text  = "";
      "Pictures/Screenshots/.keep".text = "";
      "Documents/University/.keep".text = "";
      "Documents/Work/.keep".text       = "";
      "Documents/Personal/.keep".text   = "";
    };

  };
}