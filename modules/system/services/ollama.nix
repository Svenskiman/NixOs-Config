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
