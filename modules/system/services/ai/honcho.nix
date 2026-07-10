{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.honcho.enable = lib.mkEnableOption "Honcho memory server";
  };

  config = lib.mkIf config.myModules.honcho.enable {

    systemd.services.docker-network-honcho = {
      description = "Create honcho Docker network";
      before = [
        "docker-honcho-db.service"
        "docker-honcho-redis.service"
        "docker-honcho-api.service"
        "docker-honcho-deriver.service"
      ];
      wantedBy = [
        "docker-honcho-db.service"
        "docker-honcho-redis.service"
        "docker-honcho-api.service"
        "docker-honcho-deriver.service"
      ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.docker}/bin/docker network inspect honcho-net >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create honcho-net
      '';
    };

    virtualisation.oci-containers.containers = {

      honcho-db = {
        image = "pgvector/pgvector:pg15";
        autoStart = true;
        environment = {
          POSTGRES_DB = "postgres";
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          PGDATA = "/var/lib/postgresql/data/pgdata";
        };
        volumes = [ "honcho-db-data:/var/lib/postgresql/data" ];
        extraOptions = [
          "--network=honcho-net"
          "--network-alias=honcho-db"
          "--health-cmd=pg_isready -U postgres -d postgres"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=5"
        ];
      };

      honcho-redis = {
        image = "redis:8.2";
        autoStart = true;
        volumes = [ "honcho-redis-data:/data" ];
        extraOptions = [
          "--network=honcho-net"
          "--network-alias=honcho-redis"
          "--health-cmd=redis-cli ping"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=5"
        ];
      };

      honcho-api = {
        image = "ghcr.io/plastic-labs/honcho:latest";
        autoStart = true;
        dependsOn = [
          "honcho-db"
          "honcho-redis"
        ];
        ports = [ "127.0.0.1:8000:8000" ];
        environment = {
          DB_CONNECTION_URI = "postgresql+psycopg://postgres:postgres@honcho-db:5432/postgres";
          CACHE_URL = "redis://honcho-redis:6379/0?suppress=true";
          CACHE_ENABLED = "true";
          LLM_OPENAI_COMPATIBLE_BASE_URL = "http://localhost:8080/v1";
          LLM_OPENAI_COMPATIBLE_API_KEY = "dummy";
        };
        extraOptions = [
          "--network=honcho-net"
          "--network-alias=honcho-api"
          "--add-host=host.docker.internal:host-gateway"
        ];
      };

      honcho-deriver = {
        image = "ghcr.io/plastic-labs/honcho:latest";
        autoStart = true;
        dependsOn = [
          "honcho-db"
          "honcho-redis"
        ];
        entrypoint = "/app/.venv/bin/python";
        cmd = [
          "-m"
          "src.deriver"
        ];
        environment = {
          DB_CONNECTION_URI = "postgresql+psycopg://postgres:postgres@honcho-db:5432/postgres";
          CACHE_URL = "redis://honcho-redis:6379/0?suppress=true";
          CACHE_ENABLED = "true";
          LLM_OPENAI_COMPATIBLE_BASE_URL = "http://host.docker.internal:8080/v1";
          LLM_OPENAI_COMPATIBLE_API_KEY = "dummy";
        };
        extraOptions = [
          "--network=honcho-net"
          "--network-alias=honcho-deriver"
          "--add-host=host.docker.internal:host-gateway"
        ];
      };

    };

    systemd.services.docker-honcho-deriver = {
      after = [ "docker-honcho-api.service" ];
      requires = [ "docker-honcho-api.service" ];
    };

  };
}
