{ lib, config, pkgs, ... }:

{
    options = {
        myModules.evince.enable = lib.mkEnableOption "Evince document viewer";
    };

    config = lib.mkIf config.myModules.evince.enable {

        home.packages = [ pkgs.evince ];

        xdg.mimeApps.defaultApplications = {
            "application/pdf" = [ "org.gnome.Evince.desktop" ];
        };

    };
}