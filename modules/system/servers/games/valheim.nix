{ lib, config, ... }:

{
    options = {
        myModules.servers.games.valheim.enable = lib.mkEnableOption "Valheim server";
    };

    config = lib.mkIf config.myModules.servers.games.valheim.enable {

        virtualisation.oci-containers.containers = {

            valheim = {
                image = "ghcr.io/lloesche/valheim-server:latest";
                autoStart = false;
                ports = [ "2456-2457:2456-2457/udp" ];
                volumes = [
                    "/home/shrike/Servers/Valheim/chudheim:/config"
                    "/home/shrike/Backups/Valheim/chudheim:/config/backups"
                    "${config.sops.secrets.valheim_server_password.path}:/run/secrets/valheim_server_password:ro"
                ];
                environment = {
                    SERVER_NAME = "Chudheim";
                    WORLD_NAME = "Chudheim";
                    SERVER_PUBLIC = "false";
                    SERVER_PASS_FILE = "/run/secrets/valheim_server_password";
                    TZ = "Europe/London";
                    BACKUPS = "true";
                    BACKUPS_CRON = "0 * * * *";
                    BACKUPS_MAX_AGE = "7";
                    BACKUPS_ZIP = "true";
                    SERVER_ARGS = builtins.concatStringsSep " " [
                        "-modifier combat normal"
                        "-modifier deathpenalty normal"
                        "-modifier resources more"
                        "-modifier raids normal"
                        "-modifier portals normal"
                    ];
                };
                extraOptions = [ "--cap-add=sys_nice" "--stop-timeout=120" ];
            };

        };

        networking.firewall.allowedUDPPortRanges = [
            { from = 2456; to = 2457; }
        ];
    };
}