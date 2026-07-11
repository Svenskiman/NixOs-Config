{
  lib,
  config,
  pkgs,
  ...
}:

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
            "hf-repo" = "Jackrong/Qwopus3.5-9B-Coder-GGUF";
            "hf-file" = "Qwopus3.5-9B-coder-Exp-Q4_K_M.gguf";
            "ctx-size" = 131072;
            "n-gpu-layers" = 999;
            "flash-attn" = "on";
          };
        };

        systemd.services.llama-cpp = {
          environment = {
            XDG_CACHE_HOME = "/var/cache/llama-cpp";
            MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
            HSA_OVERRIDE_GFX_VERSION = "11.0.0";
          };
          wantedBy = lib.mkForce [ ];
        };
      })

      # services.llama-cpp only supports a single instance, so the embedding
      # server is defined as a raw systemd service instead of using the NixOS module.
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
