{ lib, ... }:

{
  options.myModules.ai = {
    remote = {
      enable = lib.mkEnableOption "remote OpenAI-compatible endpoint";

      displayName = lib.mkOption {
        type = lib.types.str;
        default = "Remote (vLLM)";
        description = "Provider name shown in the OpenCode model picker";
      };

      baseURL = lib.mkOption {
        type = lib.types.str;
        description = "Base URL including the /v1 suffix";
      };

      modelId = lib.mkOption {
        type = lib.types.str;
        description = "Model id exactly as returned by GET /v1/models";
      };

      modelName = lib.mkOption {
        type = lib.types.str;
        default = "Remote model";
        description = "Display name for the model";
      };

      contextLength = lib.mkOption {
        type = lib.types.int;
        default = 262144;
        description = "Must match the server's max_model_len";
      };

      maxOutputTokens = lib.mkOption {
        type = lib.types.int;
        default = 32768;
      };

      searxngURL = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SearXNG base URL; null disables the MCP server";
      };

      crawl4aiURL = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Crawl4AI base URL; null disables the MCP server";
      };
    };
  };
}
