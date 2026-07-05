{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.nautilus.enable = lib.mkEnableOption "Nautilus file manager";
  };

  config = lib.mkIf config.myModules.nautilus.enable {

    home.packages = [
      pkgs.nautilus
      pkgs.yaru-theme
    ];

    gtk.iconTheme = {
      name = "Yaru-blue";
      package = pkgs.yaru-theme;
    };

    gtk.gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        icon-theme = "Yaru-blue";
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
      };
    };

    xdg.enable = true;
  };
}
