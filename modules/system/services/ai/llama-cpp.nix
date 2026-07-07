{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.llamaCpp.enable = lib.mkEnableOption "llama.cpp server";
  };

  config = lib.mkIf config.myModules.llamaCpp.enable {

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

    services.llama-cpp = {
      enable = true;
      package = pkgs.llama-cpp-rocm;

      settings = {
        host = "127.0.0.1";
        port = 8080;
        "hf-repo" = "Jackrong/Qwopus3.5-9B-Coder-GGUF";
        "hf-file" = "Qwopus3.5-9B-coder-Exp-Q4_K_M.gguf";
        "ctx-size" = 131072;
        "n-gpu-layers" = 999;
        "flash-attn" = "on";
      };
    };

    systemd.services.llama-cpp.environment = {
      XDG_CACHE_HOME = "/var/cache/llama-cpp";
      MESA_SHADER_CACHE_DIR = "/var/cache/llama-cpp";
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };
}
