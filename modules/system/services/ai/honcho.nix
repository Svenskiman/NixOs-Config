{
  lib,
  config,
  pkgs,
  ...
}:

let
  localLLM = "http://host.docker.internal:8080/v1";
  localModel = "Crownelius/Crow-9B-HERETIC-4.6";
  commonLLMEnv = {
    LLM_OPENAI_API_KEY = "dummy";

    DERIVER_MODEL_CONFIG__MODEL = localModel;
    DERIVER_MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;
    DERIVER_MODEL_CONFIG__STRUCTURED_OUTPUT_MODE = "json_object";

    SUMMARY_MODEL_CONFIG__MODEL = localModel;
    SUMMARY_MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;

    DIALECTIC_LEVELS__minimal__MODEL_CONFIG__MODEL = localModel;
    DIALECTIC_LEVELS__minimal__MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;
    DIALECTIC_LEVELS__low__MODEL_CONFIG__MODEL = localModel;
    DIALECTIC_LEVELS__low__MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;
    DIALECTIC_LEVELS__medium__MODEL_CONFIG__MODEL = localModel;
    DIALECTIC_LEVELS__medium__MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;
    DIALECTIC_LEVELS__high__MODEL_CONFIG__MODEL = localModel;
    DIALECTIC_LEVELS__high__MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;
    DIALECTIC_LEVELS__max__MODEL_CONFIG__MODEL = localModel;
    DIALECTIC_LEVELS__max__MODEL_CONFIG__OVERRIDES__BASE_URL = localLLM;

    EMBEDDING_MODEL_CONFIG__TRANSPORT = "openai";
    EMBEDDING_MODEL_CONFIG__MODEL = "nomic-ai/nomic-embed-text-v2-moe";
    EMBEDDING_MODEL_CONFIG__OVERRIDES__BASE_URL = "http://host.docker.internal:8081/v1";
    EMBEDDING_VECTOR_DIMENSIONS = "768";
  };
in

{
  options = {
    myModules.honcho.enable = lib.mkEnableOption "Honcho memory server";
  };

  config = lib.mkIf config.myModules.honcho.enable {

    # Needed otherwise we cant connect when firewall is enabled
    networking.firewall.trustedInterfaces = [
      "docker0"
      "honcho-net"
    ];

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
        ${pkgs.docker}/bin/docker network create -o "com.docker.network.bridge.name=honcho-net" honcho-net
      '';
    };

    virtualisation.oci-containers.containers = {

      honcho-db = {
        image = "pgvector/pgvector:pg15";
        autoStart = false;
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
        autoStart = false;
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
        autoStart = false;
        dependsOn = [
          "honcho-db"
          "honcho-redis"
        ];
        ports = [ "127.0.0.1:8000:8000" ];
        environment = {
          DB_CONNECTION_URI = "postgresql+psycopg://postgres:postgres@honcho-db:5432/postgres";
          CACHE_URL = "redis://honcho-redis:6379/0?suppress=true";
          CACHE_ENABLED = "true";
        }
        // commonLLMEnv;
        extraOptions = [
          "--network=honcho-net"
          "--network-alias=honcho-api"
          "--add-host=host.docker.internal:host-gateway"
        ];
      };

      honcho-deriver = {
        image = "ghcr.io/plastic-labs/honcho:latest";
        autoStart = false;
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
        }
        // commonLLMEnv;
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
