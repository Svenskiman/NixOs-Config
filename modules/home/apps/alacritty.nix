{
  lib,
  pkgs,
  config,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;

  # Import Gruvbox theme for Darwin (static, no theme switching)
  gruvbox = import ../themes/definitions/gruvbox.nix;
in
{
  options = {
    myModules.alacritty.enable = lib.mkEnableOption "Alacritty terminal config";
  };

  config = lib.mkIf config.myModules.alacritty.enable {

    programs.alacritty = {
      enable = true;
      package = lib.mkIf isDarwin (lib.mkForce null); # Darwin: use Homebrew cask, not Nix package
      settings = {
        general.import = lib.mkIf (!isDarwin) [
          "${config.home.homeDirectory}/.config/alacritty/colors.toml"
        ];

        window = {
          padding = {
            x = 16;
            y = 8;
          };
          decorations = if isDarwin then "full" else "none";
        };

        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
        };

        # Darwin: use Gruvbox colors directly
        colors = lib.mkIf isDarwin {
          primary = {
            background = gruvbox.colors.background;
            foreground = gruvbox.colors.foreground;
          };
          cursor = {
            text = gruvbox.colors.background;
            cursor = gruvbox.colors.cursor;
          };
          selection = {
            text = gruvbox.colors.selection_foreground;
            background = gruvbox.colors.selection_background;
          };
          normal = {
            black = gruvbox.colors.color0;
            red = gruvbox.colors.color1;
            green = gruvbox.colors.color2;
            yellow = gruvbox.colors.color3;
            blue = gruvbox.colors.color4;
            magenta = gruvbox.colors.color5;
            cyan = gruvbox.colors.color6;
            white = gruvbox.colors.color7;
          };
          bright = {
            black = gruvbox.colors.color8;
            red = gruvbox.colors.color9;
            green = gruvbox.colors.color10;
            yellow = gruvbox.colors.color11;
            blue = gruvbox.colors.color12;
            magenta = gruvbox.colors.color13;
            cyan = gruvbox.colors.color14;
            white = gruvbox.colors.color15;
          };
        };
      };
    };
  };
}
