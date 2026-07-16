{
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/system/default.nix
  ];

  networking.hostName = "hyperion";
  programs.zsh.enable = true;
  time.timeZone = "Europe/London";

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    efi.canTouchEfiVariables = false;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  myModules = {
    networking.enable = true;
    tailscale.enable = true;
    docker.enable = true;
    secrets.enable = true;

    # Dockerized servers
    servers = {
      games = {
        minecraft.enable = true;
        valheim.enable = true;
        palworld.enable = true;
      };
    };
  };

  # Server secrets
  sops = {
    defaultSopsFile = ./secrets.yaml;

    secrets = {
      minecraft_friends_rcon_password.owner = "shrike";
      valheim_server_password.owner = "shrike";
      palworld_server_password.owner = "shrike";
      palworld_admin_password.owner = "shrike";
    };

    # Needed if secrets file is not supported
    templates = {
      "palworld-da-bois.env" = {
        owner = "root";
        content = ''
          SERVER_PASSWORD=${config.sops.placeholder.palworld_server_password}
          ADMIN_PASSWORD=${config.sops.placeholder.palworld_admin_password}
        '';
      };
    };
  };

  system.stateVersion = "26.05";
}
