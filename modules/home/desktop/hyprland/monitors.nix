{ lib, config, ... }:

let
  makeMonitorLua =
    monitor:
    let
      base = "hl.monitor({ output = \"${monitor.output}\", mode = \"${monitor.mode}\", position = \"${monitor.position}\", scale = ${toString monitor.scale}";
      transform = lib.optionalString (
        monitor.transform != 0
      ) ", transform = ${toString monitor.transform}";
      bitdepth = lib.optionalString (
        monitor.bitdepth != null
      ) ",  bitdepth = ${toString monitor.bitdepth}";
    in
    "${base}${transform}${bitdepth} })\n";
in

{
  options = {
    myModules.hypr.monitors = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            output = lib.mkOption { type = lib.types.str; };
            mode = lib.mkOption {
              type = lib.types.str;
              default = "preferred";
            };
            position = lib.mkOption {
              type = lib.types.str;
              default = "auto";
            };
            scale = lib.mkOption {
              type = lib.types.float;
              default = 1.0;
            };
            transform = lib.mkOption {
              type = lib.types.int;
              default = 0;
            };
            bitdepth = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
            };
          };
        }
      );
      default = [ ];
    };
  };

  config = lib.mkIf config.myModules.hypr.enable {
    wayland.windowManager.hyprland.extraConfig = ''
      -- Monitors --
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
    ''
    + lib.concatMapStrings makeMonitorLua config.myModules.hypr.monitors;
  };
}
