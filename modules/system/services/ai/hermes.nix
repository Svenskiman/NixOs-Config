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
        # Create custom model
        # ollama show qwen3.6:27b-q4_K_M --modelfile > /tmp/qwen-modelfile
        # echo 'PARAMETER num_ctx 65536' >> /tmp/qwen-modelfile
        # echo 'PARAMETER num_predict 16384' >> /tmp/qwen-modelfile
        # sudo ollama create qwen3.6-hermes -f /tmp/qwen-modelfile
        model = {
          provider = "custom";
          base_url = "http://localhost:11434/v1";
          default = "qwen3.6-hermes";
          context_length = 65536;
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
