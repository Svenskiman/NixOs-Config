{ lib, config, pkgs, ... }:

{
    options = {
        myModules.imv.enable = lib.mkEnableOption "imv image viewer";
    };

    config = lib.mkIf config.myModules.imv.enable {

        home.packages = [ pkgs.imv ];

        xdg.mimeApps = {
            enable = true;
            defaultApplications = {
                "image/png"     = [ "imv.desktop" ];
                "image/jpeg"    = [ "imv.desktop" ];
                "image/gif"     = [ "imv.desktop" ];
                "image/webp"    = [ "imv.desktop" ];
                "image/bmp"     = [ "imv.desktop" ];
                "image/tiff"    = [ "imv.desktop" ];
                "image/svg+xml" = [ "imv.desktop" ];
            };
        };

    };
}