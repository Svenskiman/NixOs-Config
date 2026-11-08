{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myModules.servers.games.minecraft;

  fahareDataDir = "/home/shrike/Servers/Minecraft/fahare";

  # Written into plugins/Fahare/config.yml before each start
  fahareConfig = pkgs.writeText "fahare-config.yml" ''
    # Managed by NixOS (minecraft.nix) - edits here are overwritten on start.

    # Keep old worlds in <data>/fahare-backups/<date>-N instead of deleting them.
    backup: true

    # Reset automatically rather than only via /fahare reset.
    auto-reset: true

    # Reset as soon as ANY player dies.
    any-death: true

    # Lives per player before they count as dead.
    lives: 1
  '';
in
{
  options.myModules.servers.games.minecraft = {
    friends.enable = lib.mkEnableOption "Minecraft friends server";
    fahare.enable = lib.mkEnableOption "Minecraft hardcore-reset (Fahare) server";
  };

  config = lib.mkMerge [

    # ---------------------------------------------------------------------
    # Friends server
    # ---------------------------------------------------------------------
    (lib.mkIf cfg.friends.enable {

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
    })

    # ---------------------------------------------------------------------
    # Hardcore reset server (Fahare): any death wipes the world for everyone.
    # Start with: sudo systemctl start docker-mc-fahare
    # ---------------------------------------------------------------------
    (lib.mkIf cfg.fahare.enable {

      virtualisation.oci-containers.containers.mc-fahare = {
        image = "itzg/minecraft-server:latest";
        autoStart = false;
        ports = [ "25566:25565" ];
        volumes = [ "${fahareDataDir}:/data" ];
        environment = {
          EULA = "TRUE";
          TYPE = "PAPER";
          VERSION = "26.1.2"; # Fahare supports up to 26.1.x
          MEMORY = "16G";
          MODRINTH_PROJECTS = "fahare";
          SPAWN_PROTECTION = "0";
          VIEW_DISTANCE = "16";
          MODE = "survival";
          # Fahare enables hardcore hearts itself when difficulty is hard.
          # Don't set HARDCORE (vanilla) or SEED (Fahare would reuse it on every reset).
          DIFFICULTY = "hard";
          USE_AIKAR_FLAGS = "true";
          TZ = "Europe/London";
          OPS = "BodaciosBaryonyx";
          ENABLE_WHITELIST = "true";
          ENFORCE_WHITELIST = "true";
          WHITELIST = "BodaciosBaryonyx,umbald,H2ouk,Charung,lord_slippy,Truhero123";
        };
        extraOptions = [ "--stop-timeout=60" ];
      };

      # Ensure the data dir is owned by shrike (Docker would otherwise create it as root),
      # then drop in the Nix-managed Fahare config before the container starts.
      # Starting this server stops the friends server (they share port 38079), and vice versa.
      systemd.services.docker-mc-fahare = {
        conflicts = [ "docker-mc-friends.service" ];
        preStart = lib.mkBefore ''
          ${pkgs.coreutils}/bin/install -d -o shrike -g users ${fahareDataDir} ${fahareDataDir}/plugins ${fahareDataDir}/plugins/Fahare
          ${pkgs.coreutils}/bin/install -m 644 -o shrike -g users ${fahareConfig} ${fahareDataDir}/plugins/Fahare/config.yml
        '';
      };

      networking.firewall.allowedTCPPorts = [ 25566 ];
    })
  ];
}