{ lib, config, pkgs, ... }:

let
    onlyoffice-scaled = pkgs.writeShellScriptBin "onlyoffice-desktopeditors" ''
        QT_SCALE_FACTOR=1 \
        QT_AUTO_SCREEN_SCALE_FACTOR=0 \
        QT_QPA_PLATFORM=xcb \
        exec ${pkgs.onlyoffice-desktopeditors}/bin/onlyoffice-desktopeditors "$@"
    '';
in

{
    options = {
        myModules.onlyoffice.enable = lib.mkEnableOption "OnlyOffice Desktop Editors";
    };

    config = lib.mkIf config.myModules.onlyoffice.enable {

        home.packages = [ onlyoffice-scaled ];

        xdg.dataFile."applications/onlyoffice-desktopeditors.desktop".text = ''
            [Desktop Entry]
            Type=Application
            Name=Only Office
            GenericName=Document Editor
            Comment=Edit office documents
            Exec=onlyoffice-desktopeditors %U
            Terminal=false
            Icon=onlyoffice-desktopeditors
            Categories=Office;WordProcessor;Spreadsheet;Presentation;
            StartupWMClass=ONLYOFFICE
        '';
    };
}