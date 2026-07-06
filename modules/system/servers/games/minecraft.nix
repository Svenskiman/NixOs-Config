{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.servers.games.minecraft.enable = lib.mkEnableOption "Minecraft friends server";
  };

  config = lib.mkIf config.myModules.servers.games.minecraft.enable {

    # Create a dedicated Docker network so containers can resolve each other by name
    systemd.services.docker-network-mc-friends = {
      description = "Create mc-friends Docker network";
      before = [
        "docker-mc-friends.service"
        "docker-mc-friends-backup.service"
      ];
      wantedBy = [ "docker-mc-friends.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.docker}/bin/docker network inspect mc-friends-net >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create mc-friends-net
      '';
    };

    virtualisation.oci-containers.containers = {

      mc-friends = {
        image = "itzg/minecraft-server:latest";
        autoStart = false;
        ports = [ "38079:25565" ];
        volumes = [
          "/home/shrike/Servers/Minecraft/friends:/data"
          "${config.sops.secrets.minecraft_friends_rcon_password.path}:/run/secrets/minecraft_friends_rcon_password:ro"
        ];
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
          RCON_PASSWORD_FILE = "/run/secrets/minecraft_friends_rcon_password";
        };
        extraOptions = [
          "--network=mc-friends-net"
          "--network-alias=mc-friends"
        ];
      };

      mc-friends-backup = {
        image = "itzg/mc-backup:latest";
        autoStart = false;
        dependsOn = [ "mc-friends" ];
        volumes = [
          "/home/shrike/Servers/Minecraft/friends:/data:ro"
          "/home/shrike/Backups/Minecraft/friends:/backups"
          "${config.sops.secrets.minecraft_friends_rcon_password.path}:/run/secrets/minecraft_friends_rcon_password:ro"
        ];
        environment = {
          CRON_SCHEDULE = "0 0 * * *";
          RCON_HOST = "mc-friends";
          RCON_PASSWORD_FILE = "/run/secrets/minecraft_friends_rcon_password";
          TZ = "Europe/London";
          PRUNE_BACKUPS_DAYS = "7";
        };
        extraOptions = [ "--network=mc-friends-net" ];
      };

    };

    # Start backup container with server
    systemd.services.docker-mc-friends-backup = {
      bindsTo = [ "docker-mc-friends.service" ];
      after = [ "docker-mc-friends.service" ];
      wantedBy = [ "docker-mc-friends.service" ];
    };

    networking.firewall.allowedTCPPorts = [ 38079 ];
  };
}
