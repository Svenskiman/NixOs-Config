{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  remote = osConfig.myModules.ai.remote;

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    model = "keats/${remote.modelId}";
    small_model = "keats/${remote.modelId}";

    provider.keats = {
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

    plugin = [ ];

    mcp =
      (lib.optionalAttrs (remote.searxngURL != null) {
        searxng = {
          type = "local";
          command = [
            "npx"
            "-y"
            "mcp-searxng"
          ];
          enabled = true;
          environment.SEARXNG_URL = remote.searxngURL;
        };
      })
      // (lib.optionalAttrs (remote.crawl4aiURL != null) {
        crawl4ai = {
          type = "local";
          command = [
            "npx"
            "-y"
            "mcp-crawl4ai-ts"
          ];
          enabled = true;
          environment.CRAWL4AI_BASE_URL = remote.crawl4aiURL;
        };
      });
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
  };
}
