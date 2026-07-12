{
  pkgs,
  lib,
  config,
  ...
}:

let
  ai-start = pkgs.writeShellApplication {
    name = "ai-start";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      sudo systemctl start llama-swap
      sudo systemctl start llama-cpp-embed
      sudo systemctl start docker-searxng
      sudo systemctl start docker-honcho-db
      sudo systemctl start docker-honcho-redis
      sudo systemctl start docker-honcho-api
      sudo systemctl start docker-honcho-deriver
      sudo systemctl start docker-firecrawl-redis
      sudo systemctl start docker-firecrawl-rabbitmq
      sudo systemctl start docker-firecrawl-postgres
      sudo systemctl start docker-firecrawl-playwright
      sudo systemctl start docker-firecrawl-api
    '';
  };

  ai-stop = pkgs.writeShellApplication {
    name = "ai-stop";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      sudo systemctl stop docker-firecrawl-api
      sudo systemctl stop docker-firecrawl-playwright
      sudo systemctl stop docker-firecrawl-rabbitmq
      sudo systemctl stop docker-firecrawl-postgres
      sudo systemctl stop docker-firecrawl-redis
      sudo systemctl stop docker-honcho-deriver
      sudo systemctl stop docker-honcho-api
      sudo systemctl stop docker-honcho-redis
      sudo systemctl stop docker-honcho-db
      sudo systemctl stop docker-searxng
      sudo systemctl stop llama-cpp-embed
      sudo systemctl stop llama-swap
    '';
  };

  ai-status = pkgs.writeShellApplication {
    name = "ai-status";
    runtimeInputs = [
      pkgs.systemd
      pkgs.curl
    ];
    text = ''
      echo "=== Services ==="
      systemctl is-active --quiet llama-swap \
        && echo "llama-swap:        running" \
        || echo "llama-swap:        stopped"

      systemctl is-active --quiet llama-cpp-embed \
        && echo "llama-cpp (embed): running" \
        || echo "llama-cpp (embed): stopped"

      systemctl is-active --quiet docker-searxng \
        && echo "searxng:           running" \
        || echo "searxng:           stopped"

      systemctl is-active --quiet docker-honcho-db \
        && echo "honcho-db:         running" \
        || echo "honcho-db:         stopped"

      systemctl is-active --quiet docker-honcho-redis \
        && echo "honcho-redis:      running" \
        || echo "honcho-redis:      stopped"

      systemctl is-active --quiet docker-honcho-api \
        && echo "honcho-api:        running" \
        || echo "honcho-api:        stopped"

      systemctl is-active --quiet docker-honcho-deriver \
        && echo "honcho-deriver:    running" \
        || echo "honcho-deriver:    stopped"

      systemctl is-active --quiet docker-firecrawl-api \
        && echo "firecrawl:         running" \
        || echo "firecrawl:         stopped"

      echo ""
      echo "=== Health ==="
      echo -n "llama-swap:      "
      curl -sf http://localhost:8080/health || echo "unreachable"
      echo ""

      echo -n "llama-cpp embed: "
      curl -sf http://localhost:8081/health || echo "unreachable"
      echo ""

      echo -n "honcho api:      "
      curl -sf http://localhost:8000/health || echo "unreachable"
      echo ""

      echo -n "searxng:         "
      curl -sf http://localhost:8123 > /dev/null && echo '{"status":"ok"}' || echo "unreachable"

      echo -n "firecrawl:       "
      curl -sf http://localhost:3002 > /dev/null && echo '{"status":"ok"}' || echo "unreachable"
    '';
  };
in

{
  options = {
    myModules.scripts.aiLocal.enable = lib.mkEnableOption "AI local stack scripts";
  };

  config = lib.mkIf config.myModules.scripts.aiLocal.enable {
    home.packages = [
      ai-start
      ai-stop
      ai-status
    ];
  };
}
