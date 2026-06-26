{ lib, config, pkgs, ... }:

let
    keepassxc-scaled = pkgs.writeShellScriptBin "keepassxc" ''
        QT_SCALE_FACTOR=1 exec ${pkgs.keepassxc}/bin/keepassxc "$@"
    '';

    desktopEntry = ''
        [Desktop Entry]
        Name=KeePassXC
        GenericName=Password Manager
        Exec=keepassxc %U
        Icon=${pkgs.keepassxc}/share/icons/hicolor/256x256/apps/keepassxc.png
        Type=Application
        Terminal=false
        Categories=Utility;Security;Qt;
        MimeType=application/x-keepass2;
    '';
in

{
    options = {
        myModules.keepassxc.enable = lib.mkEnableOption "KeePassXC";
    };

    config = lib.mkIf config.myModules.keepassxc.enable {

        home.packages = [ keepassxc-scaled ];

        xdg.autostart.enable = true;
        xdg.configFile."autostart/keepassxc.desktop".text = desktopEntry;
        xdg.dataFile."applications/keepassxc.desktop".text = desktopEntry;
    };
}