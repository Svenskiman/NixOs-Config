{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myModules.ai;

  llamaServer = "${pkgs.llama-cpp-rocm}/bin/llama-server";

  chatTemplateQwen = pkgs.fetchurl {
    url = "https://huggingface.co/froggeric/Qwen-Fixed-Chat-Templates/resolve/main/chat_template.jinja";
    hash = "sha256-0gPzNC2Kf4R03VVWPuzjom5xshxvZnyduck7dis7+Zc=";
  };

  mkCmd = m: thinking: ''
    env XDG_CACHE_HOME=/var/cache/llama-cpp \
    ${llamaServer} \
      --port ''${PORT} \
      --host 0.0.0.0 \
      --hf-repo ${m.hfRepo} \
      --hf-file ${m.hfFile} \
      --ctx-size ${toString m.contextLength} \
      -ngl ${toString m.gpuLayers} \
      --flash-attn on \
      --temp ${toString m.temperature} \
      --top-p ${toString m.topP} \
      --top-k ${toString m.topK} \
      --repeat-penalty ${toString m.repeatPenalty} \
      --no-webui \
      ${lib.optionalString (m.templateFix == "qwen") ''
        --jinja \
        --chat-template-file ${chatTemplateQwen} \
      ''}
      ${lib.optionalString m.hasThinking ''
        --chat-template-kwargs '{"enable_thinking":${if thinking then "true" else "false"}}' \
      ''}
  '';

  mkModelEntries =
    name: m:
    if m.hasThinking then
      {
        "${name}_T" = {
          cmd = mkCmd m true;
          aliases = lib.optional (name == cfg.activeModel) "honcho";
        };
        "${name}_NT" = {
          cmd = mkCmd m false;
        };
      }
    else
      {
        "${name}" = {
          cmd = mkCmd m false;
          aliases = lib.optional (name == cfg.activeModel) "honcho";
        };
      };

  allModels = lib.foldlAttrs (
    acc: name: m:
    acc // mkModelEntries name m
  ) { } cfg.models;

in

{
  options.myModules.llamaSwap = {
    enable = lib.mkEnableOption "llama-swap model manager";
    embed.enable = lib.mkEnableOption "llama.cpp embedding server";
  };

  config = lib.mkIf config.myModules.llamaSwap.enable (
    lib.mkMerge [

      {
        users.users.llama-swap = {
          isSystemUser = true;
          group = "llama-swap";
        };
        users.groups.llama-swap = { };

        systemd.tmpfiles.rules = [
          "d /var/cache/llama-cpp 0755 llama-swap llama-swap -"
          "L+ /opt/rocm - - - - ${
            pkgs.symlinkJoin {
              name = "rocm-combined";
              paths = with pkgs.rocmPackages; [
                rocblas
                hipblas
                clr
              ];
            }
          }"
        ];

        services.llama-swap = {
          enable = true;
          settings = {
            includeAliasesInList = true;
            startPort = 5800;
            env = [ "XDG_CACHE_HOME=/var/cache/llama-cpp" ];
            models = allModels;
          };
        };

        systemd.services.llama-swap = {
          environment = {
            XDG_CACHE_HOME = "/var/cache/llama-cpp";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
            HSA_OVERRIDE_GFX_VERSION = "11.0.0";
          };
          serviceConfig = {
            DynamicUser = lib.mkForce false;
            User = "llama-swap";
            Group = "llama-swap";
            CacheDirectory = lib.mkForce "";
          };
        };
      }

      (lib.mkIf config.myModules.llamaSwap.embed.enable {
        systemd.services.llama-cpp-embed = {
          description = "llama.cpp embedding server (nomic-embed-text-v2)";
          after = [ "network.target" ];
          wantedBy = [ ];
          environment = {
            XDG_CACHE_HOME = "/var/cache/llama-cpp";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
            HSA_OVERRIDE_GFX_VERSION = "11.0.0";
          };
          serviceConfig = {
            Type = "simple";
            Restart = "on-failure";
            User = "llama-swap";
            Group = "llama-swap";
            ExecStart = ''
              ${llamaServer} \
                --log-disable \
                --host 0.0.0.0 \
                --port 8081 \
                --hf-repo nomic-ai/nomic-embed-text-v2-moe-GGUF \
                --hf-file nomic-embed-text-v2-moe.Q8_0.gguf \
                --embeddings \
                --pooling mean \
                -ngl 0 \
                -c 8192
            '';
          };
        };
      })

    ]
  );
}
