{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.firecrawl.enable = lib.mkEnableOption "Self-hosted Firecrawl scraping service";
  };

  config = lib.mkIf config.myModules.firecrawl.enable {

    systemd.services.docker-network-firecrawl = {
      description = "Create firecrawl Docker network";
      before = [
        "docker-firecrawl-redis.service"
        "docker-firecrawl-rabbitmq.service"
        "docker-firecrawl-postgres.service"
        "docker-firecrawl-playwright.service"
        "docker-firecrawl-api.service"
      ];
      wantedBy = [
        "docker-firecrawl-redis.service"
        "docker-firecrawl-rabbitmq.service"
        "docker-firecrawl-postgres.service"
        "docker-firecrawl-playwright.service"
        "docker-firecrawl-api.service"
      ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.docker}/bin/docker network inspect firecrawl-net >/dev/null 2>&1 || \
        ${pkgs.docker}/bin/docker network create firecrawl-net
      '';
    };

    virtualisation.oci-containers.containers = {

      firecrawl-redis = {
        image = "redis:alpine";
        autoStart = false;
        extraOptions = [
          "--network=firecrawl-net"
          "--network-alias=redis"
        ];
      };

      firecrawl-rabbitmq = {
        image = "rabbitmq:3-management";
        autoStart = false;
        extraOptions = [
          "--network=firecrawl-net"
          "--network-alias=rabbitmq"
          "--health-cmd=rabbitmq-diagnostics -q check_running"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };

      firecrawl-postgres = {
        image = "ghcr.io/firecrawl/nuq-postgres:latest";
        autoStart = false;
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "postgres";
        };
        extraOptions = [
          "--network=firecrawl-net"
          "--network-alias=nuq-postgres"
        ];
      };

      firecrawl-playwright = {
        image = "ghcr.io/firecrawl/playwright-service:latest";
        autoStart = false;
        environment = {
          PORT = "3000";
        };
        extraOptions = [
          "--network=firecrawl-net"
          "--network-alias=playwright-service"
          "--shm-size=1g"
        ];
      };

      firecrawl-api = {
        image = "ghcr.io/firecrawl/firecrawl:2.11.87-production";
        autoStart = false;
        dependsOn = [
          "firecrawl-redis"
          "firecrawl-rabbitmq"
          "firecrawl-postgres"
          "firecrawl-playwright"
        ];
        ports = [ "3002:3002" ];
        environment = {
          HOST = "0.0.0.0";
          PORT = "3002";
          USE_DB_AUTHENTICATION = "false";
          REDIS_URL = "redis://redis:6379";
          REDIS_RATE_LIMIT_URL = "redis://redis:6379";
          PLAYWRIGHT_MICROSERVICE_URL = "http://playwright-service:3000/scrape";
          NUQ_RABBITMQ_URL = "amqp://rabbitmq:5672";
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "postgres";
          POSTGRES_HOST = "nuq-postgres";
          POSTGRES_PORT = "5432";
          BULL_AUTH_KEY = "localonly";
        };
        extraOptions = [
          "--network=firecrawl-net"
          "--add-host=host.docker.internal:host-gateway"
        ];
      };

    };

    systemd.services.docker-firecrawl-api = {
      after = [
        "docker-firecrawl-redis.service"
        "docker-firecrawl-rabbitmq.service"
        "docker-firecrawl-postgres.service"
        "docker-firecrawl-playwright.service"
      ];
    };

  };
}
