{ lib, config, ... }:

{
  config = lib.mkIf config.myModules.clamshell.enable {
    wayland.windowManager.hyprland.extraConfig = ''

      -- Clamshell --
      hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd("hyprland-monitor-internal off"))
      hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprland-monitor-internal on"))
    '';
  };
}
