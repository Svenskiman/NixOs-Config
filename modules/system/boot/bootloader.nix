{ lib, config, ... }:

{
    options = {
        myModules.boot.enable = lib.mkEnableOption "Systemd-boot bootloader";
    };

    config = lib.mkIf config.myModules.boot.enable {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot.configurationLimit = 5;
        boot.loader.timeout = 0; # Hold space to open GRUB
    };
}