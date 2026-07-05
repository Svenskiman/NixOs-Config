{ lib, config, ... }:

{
  options = {
    myModules.servers.games.palworld.enable = lib.mkEnableOption "Palworld Da-Bois server";
  };

  config = lib.mkIf config.myModules.servers.games.palworld.enable {

    virtualisation.oci-containers.containers = {

      palworld-da-bois = {
        image = "thijsvanloef/palworld-server-docker:latest";
        autoStart = false;
        ports = [
          "8211:8211/udp"
        ];
        volumes = [
          "/home/shrike/Servers/Palworld/da-bois:/palworld"
          "/home/shrike/Backups/Palworld/da-bois:/palworld/backups"
        ];
        environmentFiles = [
          config.sops.templates."palworld-da-bois.env".path
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          PORT = "8211";
          PLAYERS = "6";
          SERVER_NAME = "Da-Bois";
          MULTITHREADING = "true";
          COMMUNITY = "false";
          TZ = "Europe/London";

          # Backups
          BACKUP_ENABLED = "true";
          BACKUP_CRON_EXPRESSION = "0 0 * * *";
          DELETE_OLD_BACKUPS = "true";
          OLD_BACKUP_DAYS = "7";

          # Game world settings (defaults, explicit)
          DIFFICULTY = "None";
          DAYTIME_SPEEDRATE = "1.0";
          NIGHTTIME_SPEEDRATE = "1.0";
          EXP_RATE = "1.0";
          PAL_CAPTURE_RATE = "1.0";
          PAL_SPAWN_NUM_RATE = "1.0";
          PAL_DAMAGE_RATE_ATTACK = "1.0";
          PAL_DAMAGE_RATE_DEFENSE = "1.0";
          PLAYER_DAMAGE_RATE_ATTACK = "1.0";
          PLAYER_DAMAGE_RATE_DEFENSE = "1.0";
          PLAYER_STOMACH_DECREASE_RATE = "1.0";
          PLAYER_STAMINA_DECREASE_RATE = "1.0";
          PLAYER_AUTO_HP_REGEN_RATE = "1.0";
          PLAYER_AUTO_HP_REGEN_RATE_IN_SLEEP = "1.0";
          BUILD_OBJECT_DAMAGE_RATE = "1.0";
          BUILD_OBJECT_DETERIORATION_DAMAGE_RATE = "1.0";
          COLLECTION_DROP_RATE = "1.0";
          COLLECTION_OBJECT_HP_RATE = "1.0";
          COLLECTION_OBJECT_RESPAWN_SPEED_RATE = "1.0";
          ENEMY_DROP_ITEM_RATE = "1.0";
          DEATH_PENALTY = "All";
          ENABLE_PLAYER_TO_PLAYER_DAMAGE = "false";
          ENABLE_FRIENDLY_FIRE = "false";
          ENABLE_INVADER_ENEMY = "true";
          ACTIVE_UNKO = "false";
          ENABLE_AIM_ASSIST_PAD = "true";
          ENABLE_AIM_ASSIST_KEYBOARD = "false";
          DROP_ITEM_MAX_NUM = "3000";
          BASE_CAMP_MAX_NUM = "128";
          BASE_CAMP_WORKER_MAX_NUM = "15";
          DROP_ITEM_ALIVE_MAX_HOURS = "1.0";
          COOP_PLAYER_MAX_NUM = "4";
          GUILD_PLAYER_MAX_NUM = "20";
        };
        extraOptions = [
          "--stop-timeout=30"
          "--memory=8g"
        ];
      };

    };

    networking.firewall.allowedUDPPorts = [ 8211 ];
  };
}
