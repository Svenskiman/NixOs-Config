{ ... }:

{
  imports = [
    ./model-schema.nix
    ./models.nix
    ./hermes.nix
    ./searxng.nix
    ./llama-swap.nix
    ./honcho.nix
    ./crawl4ai.nix
    ./firecrawl.nix
  ];
}
