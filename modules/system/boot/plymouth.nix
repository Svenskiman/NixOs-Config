{ ... }:

{
    boot.plymouth = {
        enable = true;
        theme = "bgrt";
    };

    boot.kernelParams = [ "quiet" "splash" ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
}