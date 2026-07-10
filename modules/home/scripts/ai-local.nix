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
      sudo systemctl start llama-cpp
      sudo systemctl start llama-cpp-embed
      sudo systemctl start docker-searxng
      sudo systemctl start docker-honcho-db
      sudo systemctl start docker-honcho-redis
      sudo systemctl start docker-honcho-api
      sudo systemctl start docker-honcho-deriver
    '';
  };

  ai-stop = pkgs.writeShellApplication {
    name = "ai-stop";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      sudo systemctl stop docker-honcho-deriver
      sudo systemctl stop docker-honcho-api
      sudo systemctl stop docker-honcho-redis
      sudo systemctl stop docker-honcho-db
      sudo systemctl stop docker-searxng
      sudo systemctl stop llama-cpp-embed
      sudo systemctl stop llama-cpp
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
      systemctl is-active --quiet llama-cpp \
        && echo "llama-cpp (chat):  running" \
        || echo "llama-cpp (chat):  stopped"

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

      echo ""
      echo "=== Health ==="
      echo -n "llama-cpp chat:  "
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
