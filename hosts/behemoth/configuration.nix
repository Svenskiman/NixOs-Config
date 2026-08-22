{
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

    ai = {

      # DGX Spark box
      remote = {
        enable = true;
        displayName = "Keats";
        baseURL = "http://keats:8000/v1";
        modelId = "qwen";
        modelName = "Qwen3.5 122B";
        contextLength = 262144;
        maxOutputTokens = 32768;
      };

      hermes.enable = false;
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
  };

  system.stateVersion = "26.05";
}
