{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.myModules.ai;
  remote = cfg.remote;

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

  activeRef = if remote.enable then "keats/${remote.modelId}" else "local/${cfg.activeModel}";

  providers =
    if remote.enable then
      {
        keats = {
          npm = "@ai-sdk/openai-compatible";
          name = remote.displayName;
          options = {
            baseURL = remote.baseURL;
            apiKey = "dummy";
          };
          models.${remote.modelId} = {
            name = remote.modelName;
            supportsToolCalls = true;
            limit = {
              context = remote.contextLength;
              output = remote.maxOutputTokens;
            };
          };
        };
      }
    else
      {
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

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    model = activeRef;
    small_model = activeRef;
    provider = providers;

    plugin = [
      "@honcho-ai/opencode-honcho"
    ];

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

      crawl4ai = {
        type = "local";
        command = [
          "npx"
          "-y"
          "mcp-crawl4ai-ts"
        ];
        enabled = true;
        environment = {
          CRAWL4AI_BASE_URL = "http://localhost:11235";
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
