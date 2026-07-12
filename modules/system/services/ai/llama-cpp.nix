{
  lib,
  config,
  pkgs,
  ...
}:
let
  m = config.myModules.ai.model;
  chatTemplate = pkgs.fetchurl {
    url = "https://huggingface.co/froggeric/Qwen-Fixed-Chat-Templates/resolve/main/chat_template.jinja";
    hash = "sha256-0gPzNC2Kf4R03VVWPuzjom5xshxvZnyduck7dis7+Zc=";
  };
in
{
  options = {
    myModules.llamaCpp = {
      enable = lib.mkEnableOption "llama.cpp servers";
      chat.enable = lib.mkEnableOption "llama.cpp chat server";
      embed.enable = lib.mkEnableOption "llama.cpp embedding server";
    };
  };
  config = lib.mkIf config.myModules.llamaCpp.enable (
    lib.mkMerge [
      {
        systemd.tmpfiles.rules = [
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
      }
      (lib.mkIf config.myModules.llamaCpp.chat.enable {
        services.llama-cpp = {
          enable = true;
          package = pkgs.llama-cpp-rocm;
          settings = {
            host = "0.0.0.0";
            port = 8080;
            "hf-repo" = m.hfRepo;
            "hf-file" = m.hfFile;
            "ctx-size" = m.contextLength;
            "n-gpu-layers" = m.gpuLayers;
            "flash-attn" = "on";
            "temp" = m.temperature;
            "top-p" = m.topP;
            "top-k" = m.topK;
            "repeat-penalty" = m.repeatPenalty;
            "jinja" = true;
            "chat-template-file" = "${chatTemplate}";
          };
        };
        systemd.services.llama-cpp = {
          environment = {
            XDG_CACHE_HOME = "/var/cache/llama-cpp";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
            HSA_OVERRIDE_GFX_VERSION = "11.0.0";
            LLAMA_ARG_CHAT_TEMPLATE_KWARGS = builtins.toJSON {
              enable_thinking = m.thinking;
            };
          };
          wantedBy = lib.mkForce [ ];
        };
      })
      (lib.mkIf config.myModules.llamaCpp.embed.enable {
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
            ExecStart = ''
              ${pkgs.llama-cpp-rocm}/bin/llama-server \
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
