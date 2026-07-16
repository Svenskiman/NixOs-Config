{
  lib,
  config,
  ...
}:

{
  options = {
    myModules.ai.tools.searxng.enable = lib.mkEnableOption "SearXNG search engine";
  };

  config = lib.mkIf config.myModules.ai.tools.searxng.enable {
    environment.etc."searxng/limiter.toml".text = ''
      [botdetection.ip_lists]
      pass_ip = [
        "127.0.0.0/8",
        "::1",
      ]
    '';

    virtualisation.oci-containers.containers.searxng = {
      image = "searxng/searxng";
      autoStart = false;
      ports = [ "8123:8080" ];
      environmentFiles = [ config.sops.templates."searxng.env".path ];
      environment = {
        SEARXNG_BASE_URL = "http://localhost:8123/";
      };
      volumes = [
        "/etc/searxng/limiter.toml:/etc/searxng/limiter.toml:ro"
        "${./searxng-settings.yml}:/etc/searxng/settings.yml:ro"
      ];
    };
  };
}
