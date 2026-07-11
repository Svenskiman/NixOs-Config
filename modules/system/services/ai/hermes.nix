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
        model = {
          provider = "custom";
          base_url = "http://localhost:8080/v1";
          default = "Crownelius/Crow-9B-HERETIC-4.6";
          context_length = 131072;
        };

        agent = {
          max_turns = 60;
          tool_use_enforcement = true;
        };

        web = {
          backend = "searxng";
          searxng_url = "http://localhost:8123";
        };

        memory = {
          provider = "honcho";
          memory_enabled = false;
          user_profile_enabled = false;
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
