_:

{
  myModules.ai.models = {

    "qwythos_9B_Q4-K-M" = {
      hfRepo = "empero-ai/Qwythos-9B-v2-GGUF";
      hfFile = "Qwythos-9B-v2-Q4_K_M.gguf";
      contextLength = 131072;
      maxOutputTokens = 8192;
      gpuLayers = 999;
      temperature = 0.6;
      topP = 0.95;
      topK = 20;
      repeatPenalty = 1.05;
      templateFix = "qwen";
      hasThinking = true;
    };

    "qwopus_9B_Q4-K-M" = {
      hfRepo = "Jackrong/Qwopus3.5-9B-Coder-GGUF";
      hfFile = "Qwopus3.5-9B-coder-Exp-Q4_K_M.gguf";
      contextLength = 131072;
      maxOutputTokens = 8192;
      gpuLayers = 999;
      temperature = 0.6;
      topP = 0.95;
      topK = 20;
      repeatPenalty = 1.05;
      templateFix = "qwen";
      hasThinking = true;
    };

    "crow_9B_heretic_Q5-K-M" = {
      hfRepo = "Crownelius/Crow-9B-HERETIC-4.6";
      hfFile = "Qwen3.5-9B-heretic-v2.Q5_K_M.gguf";
      contextLength = 131072;
      maxOutputTokens = 8192;
      gpuLayers = 999;
      temperature = 0.6;
      topP = 0.95;
      topK = 20;
      repeatPenalty = 1.05;
      templateFix = "none";
      hasThinking = true;
    };
  };
}
