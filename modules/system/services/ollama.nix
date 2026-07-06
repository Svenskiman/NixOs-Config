{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    myModules.ollama.enable = lib.mkEnableOption "Ollama LLM service";
  };

  config = lib.mkIf config.myModules.ollama.enable {

    # https://github.com/nixos/nixpkgs/issues/487054
    systemd.services.ollama-gpu-wait = {
      description = "Wait for AMD GPU to be ready";
      before = [ "ollama.service" ];
      wantedBy = [ "ollama.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/sleep 30";
      };
    };

    services.ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      loadModels = [ "qwen3.6:27b-q4_k_m" ];
      environmentVariables = {
        ROCR_VISIBLE_DEVICES = "0";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };
  };
}
