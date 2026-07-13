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
      sudo systemctl start docker-crawl4ai
    '';
  };

  ai-stop = pkgs.writeShellApplication {
    name = "ai-stop";
    runtimeInputs = [ pkgs.systemd ];
    text = ''
      sudo systemctl stop docker-crawl4ai
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
      GREEN="\033[0;32m"
      RED="\033[0;31m"
      YELLOW="\033[0;33m"
      BLUE="\033[0;34m"
      RESET="\033[0m"

      print_service() {
        local name=$1
        local svc=$2
        printf "%-20s" "$name"
        if systemctl is-active --quiet "$svc" 2>/dev/null; then
          echo -e "''${GREEN}running''${RESET}"
        else
          echo -e "''${RED}stopped''${RESET}"
        fi
      }

      check_health() {
        local name=$1
        local url=$2
        local svc=$3
        printf "%-20s" "$name"
        if ! systemctl is-active --quiet "$svc" 2>/dev/null; then
          echo -e "''${YELLOW}stopped (skipped)''${RESET}"
          return
        fi
        if curl -sf --max-time 2 "$url" >/dev/null 2>&1; then
          echo -e "''${GREEN}ok''${RESET}"
        else
          echo -e "''${RED}unreachable''${RESET}"
        fi
      }

      echo -e "''${BLUE}=== Services ===''${RESET}"
      print_service "llama-swap:"        "llama-swap"
      print_service "llama-cpp (embed):" "llama-cpp-embed"
      print_service "searxng:"           "docker-searxng"
      print_service "honcho-db:"         "docker-honcho-db"
      print_service "honcho-redis:"      "docker-honcho-redis"
      print_service "honcho-api:"        "docker-honcho-api"
      print_service "honcho-deriver:"    "docker-honcho-deriver"
      print_service "crawl4ai:"          "docker-crawl4ai"

      echo ""
      echo -e "''${BLUE}=== Health ===''${RESET}"
      check_health "llama-swap:"        "http://localhost:8080/health" "llama-swap"
      check_health "llama-cpp (embed):" "http://localhost:8081/health" "llama-cpp-embed"
      check_health "honcho-api:"        "http://localhost:8000/health" "docker-honcho-api"
      check_health "searxng:"           "http://localhost:8123"        "docker-searxng"
      check_health "crawl4ai:"          "http://localhost:11235/health" "docker-crawl4ai"

      echo ""
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
