{ lib, ... }:

{
  options.myModules.ai.model = {
    hfRepo = lib.mkOption {
      type = lib.types.str;
      description = "HuggingFace repo ID";
      example = "Crownelius/Crow-9B-HERETIC-4.6";
    };

    hfFile = lib.mkOption {
      type = lib.types.str;
      description = "GGUF filename within the HF repo";
      example = "Qwen3.5-9B-heretic-v2.Q5_K_M.gguf";
    };

    contextLength = lib.mkOption {
      type = lib.types.int;
      default = 131072;
      description = "Context window size in tokens";
    };

    gpuLayers = lib.mkOption {
      type = lib.types.int;
      default = 999;
      description = "Number of layers to offload to GPU";
    };

    thinking = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable thinking/reasoning mode";
    };

    temperature = lib.mkOption {
      type = lib.types.float;
      default = 0.8;
      description = "Sampling temperature";
    };

    topP = lib.mkOption {
      type = lib.types.float;
      default = 0.95;
      description = "Top-p sampling";
    };

    topK = lib.mkOption {
      type = lib.types.int;
      default = 40;
      description = "Top-k sampling";
    };

    repeatPenalty = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Repeat penalty";
    };
  };
}
