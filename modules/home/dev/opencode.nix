{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:

let
  cfg = osConfig.myModules.ai;

  mkModelEntries =
    name: m:
    if m.hasThinking then
      {
        "${name}_T" = {
          name = "${name} (think)";
          supportsToolCalls = true;
          limit = {
            context = m.contextLength;
            output = m.maxOutputTokens;
          };
        };
        "${name}_NT" = {
          name = "${name} (no think)";
          supportsToolCalls = true;
          limit = {
            context = m.contextLength;
            output = m.maxOutputTokens;
          };
        };
      }
    else
      {
        "${name}" = {
          inherit name;
          supportsToolCalls = true;
          limit = {
            context = m.contextLength;
            output = m.maxOutputTokens;
          };
        };
      };

  allModels = lib.foldlAttrs (
    acc: name: m:
    acc // mkModelEntries name m
  ) { } cfg.models;

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";

    model = "local/${cfg.activeModel}";
    small_model = "local/${cfg.activeModel}";

    provider = {
      local = {
        npm = "@ai-sdk/openai-compatible";
        name = "Local (llama-swap)";
        options = {
          baseURL = "http://localhost:8080/v1";
          apiKey = "dummy";
        };
        models = allModels;
      };
    };

    plugin = [ "@honcho-ai/opencode-honcho" ];

    # Dont enable all tools or Opencode has a stroke
    tools = {
      "firecrawl_*" = false;
      firecrawl_scrape = true;
      firecrawl_search = true;
      "searxng_*" = false;
      searxng_web_search = true;
    };

    mcp = {
      searxng = {
        type = "local";
        command = [
          "npx"
          "-y"
          "mcp-searxng"
        ];
        enabled = true;
        environment = {
          SEARXNG_URL = "http://localhost:8123";
        };
      };
      firecrawl = {
        type = "local";
        command = [
          "npx"
          "-y"
          "firecrawl-mcp"
        ];
        enabled = true;
        environment = {
          FIRECRAWL_API_URL = "http://localhost:3002";
          FIRECRAWL_API_KEY = "dummy";
          FIRECRAWL_NO_SEARCH_FEEDBACK = "1";
          FIRECRAWL_NO_ENDPOINT_FEEDBACK = "1";
        };
      };
    };
  };

  honchoConfig = {
    apiKey = "local";
    peerName = "svenski";
    baseUrl = "http://localhost:8000";
    hosts = {
      opencode = {
        workspace = "opencode";
        aiPeer = "opencode";
        recallMode = "hybrid";
        sessionStrategy = "per-directory";
      };
    };
  };
in

{
  options = {
    myModules.opencode.enable = lib.mkEnableOption "OpenCode AI coding agent";
  };

  config = lib.mkIf config.myModules.opencode.enable {

    home.packages = [
      pkgs.opencode
      pkgs.nodejs
    ];

    xdg.configFile."opencode/opencode.json" = {
      text = builtins.toJSON opencodeConfig;
    };

    home.file.".honcho/config.json" = {
      text = builtins.toJSON honchoConfig;
    };

  };
}
