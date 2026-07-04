{ lib, config, ... }:

{
    options = {
        myModules.servers.games.minecraft.enable = lib.mkEnableOption "Minecraft friends server";
    };

    config = lib.mkIf config.myModules.servers.games.minecraft.enable {

        virtualisation.oci-containers.containers = {

            mc-friends = {
                image = "itzg/minecraft-server:latest";
                autoStart = false;
                ports = [ "25566:25565" ];
                volumes = [ "/home/shrike/Servers/Minecraft/friends:/data" ];
                environment = {
                    EULA = "TRUE";
                    TYPE = "PAPER";
                    VERSION = "26.1.2";
                    MEMORY = "8G";
                    SPAWN_PROTECTION = "0";
                    VIEW_DISTANCE = "16";
                    MODE = "survival";
                    DIFFICULTY = "normal";
                    USE_AIKAR_FLAGS = "true";
                    TZ = "Europe/London";
                    OPS = "BodaciosBaryonyx";
                    ENABLE_WHITELIST = "true";
                    WHITELIST = "BodaciosBaryonyx,umbald,H2ouk,Charung,lord_slippy";
                    RCON_PASSWORD = "changeme";
                };
            };

            mc-friends-backup = {
                image = "itzg/mc-backup:latest";
                autoStart = false;
                dependsOn = [ "mc-friends" ];
                volumes = [
                    "/home/shrike/Servers/Minecraft/friends:/data:ro"
                    "/home/shrike/Backups/Minecraft/friends:/backups"
                ];
                environment = {
                    CRON_SCHEDULE = "0 4 * * *";
                    RCON_HOST = "localhost";
                    RCON_PASSWORD = "changeme";
                    TZ = "Europe/London";
                };
            };

        };

        networking.firewall.allowedTCPPorts = [ 25566 ];
    };
}