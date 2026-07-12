{ lib, ... }:

let
  modelType = lib.types.submodule {
    options = {
      hfRepo = lib.mkOption {
        type = lib.types.str;
        description = "HuggingFace repo ID";
      };

      hfFile = lib.mkOption {
        type = lib.types.str;
        description = "GGUF filename within the HF repo";
      };

      contextLength = lib.mkOption {
        type = lib.types.int;
        default = 131072;
        description = "Context window size in tokens";
      };

      maxOutputTokens = lib.mkOption {
        type = lib.types.int;
        default = 8192;
        description = "Maximum output tokens per response";
      };

      gpuLayers = lib.mkOption {
        type = lib.types.int;
        default = 999;
        description = "Number of layers to offload to GPU";
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

      templateFix = lib.mkOption {
        type = lib.types.enum [
          "none"
          "qwen"
        ];
        default = "none";
        description = "Chat template fix to apply: none, or qwen (froggeric fix)";
      };

      hasThinking = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to generate think (_T) and no-think (_NT) variants";
      };
    };
  };
in

{
  options.myModules.ai = {
    models = lib.mkOption {
      type = lib.types.attrsOf modelType;
      default = { };
      description = "Named local LLM model definitions";
    };

    activeModel = lib.mkOption {
      type = lib.types.str;
      description = "Full model key as it appears in llama-swap e.g. qwythos_9B_Q4-K-M_T";
    };
  };
}
