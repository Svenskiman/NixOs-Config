{ lib, config, ... }:

{
  options = {
    myModules.crawl4ai.enable = lib.mkEnableOption "Crawl4AI web scraping service";
  };

  config = lib.mkIf config.myModules.crawl4ai.enable {

    virtualisation.oci-containers.containers = {
      crawl4ai = {
        image = "unclecode/crawl4ai:0.8.6";
        autoStart = false;
        ports = [ "11235:11235" ];
        extraOptions = [
          "--platform=linux/amd64"
          "--shm-size=1g"
          "--add-host=host.docker.internal:host-gateway"
        ];
        environment = {
          #OPENAI_BASE_URL = "http://host.docker.internal:8080/v1";
          #OPENAI_API_KEY = "dummy";
        };
      };
    };

  };
}
