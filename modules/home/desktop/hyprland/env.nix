{ lib, config, ... }:

{
  config = lib.mkIf config.myModules.hypr.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      -- Environment variables --
      hl.env("XCURSOR_THEME", "Adwaita")
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")
    '';
  };
}
