{ lib, config, ... }:

{
  options = {
    myModules.isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "True if this machine is a laptop";
    };

    myModules.applications.enable = lib.mkEnableOption "Default applications bundle";
    myModules.desktop.enable = lib.mkEnableOption "Desktop environment bundle";
    myModules.services.enable = lib.mkEnableOption "Services bundle";
    myModules.gaming.enable = lib.mkEnableOption "Gaming apps bundle";
  };

  config = lib.mkMerge [

    (lib.mkIf config.myModules.applications.enable {
      myModules.discord.enable = lib.mkDefault true;
      myModules.alacritty.enable = lib.mkDefault true;
      myModules.btop.enable = lib.mkDefault true;
      myModules.keepassxc.enable = lib.mkDefault true;
      myModules.imv.enable = lib.mkDefault true;
      myModules.evince.enable = lib.mkDefault true;
      myModules.onlyoffice.enable = lib.mkDefault true;
      myModules.nautilus.enable = lib.mkDefault true;
    })

    (lib.mkIf config.myModules.desktop.enable {
      myModules.hypr.enable = lib.mkDefault true;
      myModules.eww.enable = lib.mkDefault true;
      myModules.waybar.enable = lib.mkDefault true;
      myModules.walker.enable = lib.mkDefault true;
    })

    (lib.mkIf config.myModules.services.enable {
      myModules.swayosd.enable = lib.mkDefault true;
      myModules.wallpaper.enable = lib.mkDefault true;
      myModules.dropbox.enable = lib.mkDefault true;
      myModules.hyprlock.enable = lib.mkDefault true;
      myModules.hypridle.enable = lib.mkDefault true;
    })

    (lib.mkIf config.myModules.gaming.enable {
      myModules.prismlauncher.enable = lib.mkDefault true;
    })
  ];
}
