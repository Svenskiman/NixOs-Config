{
  lib,
  config,
  pkgs,
  ...
}:

let
  keatsModels = import ./keats-models.nix;

  mkModel = _id: model: {
    name = model.name;
    tool_call = true;
    reasoning = true;
    interleaved.field = "reasoning_content";
    limit = {
      context = model.context;
      output = model.output or 32768;
    };
  };

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    enabled_providers = [ "keats" ];

    provider.keats = {
      npm = "@ai-sdk/openai-compatible";
      name = "Keats";
      options = {
        baseURL = "http://keats:8000/v1";
        apiKey = "dummy";
      };
      models = lib.mapAttrs mkModel keatsModels;
    };
  };
in

{
  options.myModules.opencode = {
    enable = lib.mkEnableOption "OpenCode";
    jetbrains.enable = lib.mkEnableOption "OpenCode as a JetBrains AI Chat agent";
  };

  config = lib.mkIf config.myModules.opencode.enable {
    home.packages = [ pkgs.opencode ];
    xdg.configFile."opencode/opencode.json".text = builtins.toJSON opencodeConfig;

    home.file.".jetbrains/acp.json" = lib.mkIf config.myModules.opencode.jetbrains.enable {
      text = builtins.toJSON {
        agent_servers.OpenCode = {
          command = lib.getExe pkgs.opencode;
          args = [ "acp" ];
        };
      };
    };
  };
}
