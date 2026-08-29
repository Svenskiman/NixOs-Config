{ lib, config, ... }:
{
  imports = [
    ./options.nix
  ];

  options = {
    myModules.hypr.enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf config.myModules.hypr.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      extraLuaFiles = {
        vars = {
          autoLoad = false;
          content = "return " + lib.generators.toLua { } {
            monitors = config.myModules.hypr.monitors;
            workspace_monitors = config.myModules.hypr.workspaceMonitors;
            sensitivity = config.myModules.hypr.sensitivity;
            single_window_aspect_ratio = config.myModules.hypr.singleWindowAspectRatio;
            single_window_aspect_ratio_tolerance = config.myModules.hypr.singleWindowAspectRatioTolerance;
            is_laptop = config.myModules.isLaptop;
          };
        };

        bindings = ./bindings.lua;
        env = ./env.lua;
        windowrules = ./windowrules.lua;
        autostart = ./autostart.lua;
        monitors = ./monitors.lua;
        workspaces = ./workspaces.lua;
        input = ./input.lua;
        looknfeel = ./looknfeel.lua;

      };
    };
  };
}