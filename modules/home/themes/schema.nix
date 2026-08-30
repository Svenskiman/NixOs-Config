{ lib, ... }:

let
  # Schema
  colorType = lib.types.submodule {
    options = {
      background = lib.mkOption { type = lib.types.str; };
      foreground = lib.mkOption { type = lib.types.str; };
      cursor = lib.mkOption { type = lib.types.str; };
      accent = lib.mkOption { type = lib.types.str; };
      selection_background = lib.mkOption { type = lib.types.str; };
      selection_foreground = lib.mkOption { type = lib.types.str; };

      color0 = lib.mkOption { type = lib.types.str; };
      color1 = lib.mkOption { type = lib.types.str; };
      color2 = lib.mkOption { type = lib.types.str; };
      color3 = lib.mkOption { type = lib.types.str; };
      color4 = lib.mkOption { type = lib.types.str; };
      color5 = lib.mkOption { type = lib.types.str; };
      color6 = lib.mkOption { type = lib.types.str; };
      color7 = lib.mkOption { type = lib.types.str; };
      color8 = lib.mkOption { type = lib.types.str; };
      color9 = lib.mkOption { type = lib.types.str; };
      color10 = lib.mkOption { type = lib.types.str; };
      color11 = lib.mkOption { type = lib.types.str; };
      color12 = lib.mkOption { type = lib.types.str; };
      color13 = lib.mkOption { type = lib.types.str; };
      color14 = lib.mkOption { type = lib.types.str; };
      color15 = lib.mkOption { type = lib.types.str; };
    };
  };

  # Named 'roles' - can override per theme
  semanticType =
    colors:
    lib.types.submodule {
      options = {
        error = lib.mkOption {
          type = lib.types.str;
          default = colors.color1;
        };
        warning = lib.mkOption {
          type = lib.types.str;
          default = colors.color3;
        };
        success = lib.mkOption {
          type = lib.types.str;
          default = colors.color2;
        };
        muted = lib.mkOption {
          type = lib.types.str;
          default = colors.color8;
        };
      };
    };

  # VS Code theme metadata — extension to install and theme name to set.
  # settings holds any extra keys to merge into settings.json (e.g. everforest.contrast).
  vscodeType = lib.types.submodule {
    options = {
      name = lib.mkOption { type = lib.types.str; };
      extension = lib.mkOption { type = lib.types.str; };
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };
    };
  };

  themeType = lib.types.submodule (
    { config, ... }:
    {
      options = {
        name = lib.mkOption { type = lib.types.str; };
        displayName = lib.mkOption { type = lib.types.str; };
        iconTheme = lib.mkOption {
          type = lib.types.str;
          default = "Yaru-blue";
        };
        colors = lib.mkOption { type = colorType; };
        semantic = lib.mkOption {
          type = semanticType config.colors;
          default = { };
        };
        vscode = lib.mkOption {
          type = lib.types.nullOr vscodeType;
          default = null;
        };
      };
    }
  );
in

{
  options = {
    myModules.themes.definitions = lib.mkOption {
      type = lib.types.listOf themeType;
      default = [
        (import ./definitions/nord.nix)
        (import ./definitions/gruvbox.nix)
        (import ./definitions/everforest.nix)
        (import ./definitions/nocturne.nix)
        (import ./definitions/oxocarbon.nix)
      ];
    };
  };

  config = { };
}
