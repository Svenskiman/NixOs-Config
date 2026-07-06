{ lib, config, ... }:

{
  options = {
    myModules.hermes.enable = lib.mkEnableOption "Hermes AI agent";
  };

  config = lib.mkIf config.myModules.hermes.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;

      settings = {
        # Load the GGUF in LM Studio, then verify the model name with:
        # curl http://localhost:1234/v1/models
        model = {
          provider = "custom";
          base_url = "http://localhost:1234/v1";
          default = "qwopus-hermes";
          context_length = 131072;
        };

        agent = {
          max_turns = 60;
          tool_use_enforcement = true;
        };

        terminal = {
          backend = "docker";
          docker_image = "nikolaik/python-nodejs:python3.11-nodejs20";
          docker_mount_cwd_to_workspace = true;
          docker_run_as_host_user = true;
          docker_extra_args = [ "--network=host" ];
          container_persistent = true;
          timeout = 180;
        };

        web = {
          backend = "searxng";
          searxng_url = "http://localhost:8123";
        };

        memory = {
          memory_enabled = true;
          user_profile_enabled = true;
        };

        compression = {
          enabled = true;
          threshold = 0.75;
          target_ratio = 0.25;
        };

        display = {
          show_reasoning = false;
          stream = true;
        };

        tool_output = {
          max_bytes = 50000;
          max_lines = 2000;
        };
      };
    };
  };
}
