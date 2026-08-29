{ lib, ... }:
{
  options.myModules.hypr = {

    monitors = lib.mkOption {
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

    workspaceMonitors = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption { type = lib.types.int; };
            monitor = lib.mkOption { type = lib.types.str; };
          };
        }
      );
      default = [ ];
      description = "Pins a workspace ID to always open on a specific monitor";
    };

    sensitivity = lib.mkOption {
      type = lib.types.float;
      default = -0.05;
      description = "Mouse sensitivity";
    };

    singleWindowAspectRatio = lib.mkOption {
      type = lib.types.str;
      default = "0 0";
      description = "Aspect ratio for lone windows";
    };

    singleWindowAspectRatioTolerance = lib.mkOption {
      type = lib.types.float;
      default = 0.1;
      description = "Tolerance for singleWindowAspectRatio.";
    };

  };
}