{
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./drives.nix
    ./../../modules/system/default.nix
    ./../../modules/system/services/flatpak.nix
    ./../../modules/system/services/display-manager.nix
    ./../../modules/system/services/ai
  ];

  networking.hostName = "behemoth";
  time.timeZone = "Europe/London";

  # System modules
  myModules = {
    gpu = "amd";

    boot.enable = true;
    plymouth.enable = true;

    networking.enable = true;
    tailscale.enable = true;
    vpn.mullvad.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    docker.enable = true;

    # Swapping to a spark but keeping as fallback
    ai = {
      # Default model
      activeModel = "qwythos_9B_Q4-K-M";
      llamaSwap = {
        enable = false;
        embed.enable = false;
      };
      hermes.enable = false;
      tools = {
        honcho.enable = false;
        searxng.enable = false;
        crawl4ai.enable = false;
        firecrawl.enable = false;
      };
    };

    displayManager.sddm.enable = true;
    fonts.enable = true;
    hyprlock.enable = true;
    steam.enable = true;
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    nix-ld.enable = true;
  };

  services = {
    gvfs.enable = true;
    openssh = {
      enable = true;
      openFirewall = false;
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets.searxng_secret_key = { };
    templates."searxng.env" = {
      content = ''
        SEARXNG_SECRET=${config.sops.placeholder.searxng_secret_key}
      '';
      owner = "root";
    };
  };

  system.stateVersion = "26.05";
}
