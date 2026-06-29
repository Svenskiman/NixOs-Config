{ lib, ... }:

{
    options = {
        myModules.isLaptop = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "True if this machine is a laptop";
        };

        myModules.gpu = lib.mkOption {
            type = lib.types.enum [ "amd" "nvidia" "none" ];
            default = "none";
            description = "The GPU type of the machine.";
        };
    };
}