{ lib, config, ... }:

{
    options = {
        myModules.gpu = lib.mkOption {
            type = lib.types.enum [ "amd" "nvidia" "none" ];
            default = "none";
            description = "The GPU type of the machine.";
        };
    };

    config = lib.mkIf (config.myModules.gpu == "amd") {
        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };
    };
}