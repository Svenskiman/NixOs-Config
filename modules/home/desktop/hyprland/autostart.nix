{ lib, config, ... }:

{
  config = {
    wayland.windowManager.hyprland.extraConfig = ''

      -- Autostart --
      hl.on("hyprland.start", function()

          hl.exec_cmd("eww daemon")
          hl.exec_cmd("eww open bar")
          ${lib.optionalString config.myModules.isLaptop ''
            hl.exec_cmd("eww update battery-enabled=true")
          ''}

          hl.exec_cmd("nm-applet --indicator")
      end)
    '';
  };
}
