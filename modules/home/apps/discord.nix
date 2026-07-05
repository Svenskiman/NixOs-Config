{
  lib,
  config,
  pkgs,
  ...
}:

let
  discord-toggle = pkgs.writeShellApplication {
    name = "discord-toggle";
    runtimeInputs = [
      pkgs.hyprland
      pkgs.jq
    ];
    text = ''
      window=$(hyprctl clients -j | jq -e '.[] | select(.class == "discord")' || true)

      if [ -n "$window" ]; then
          workspace=$(echo "$window" | jq -r '.workspace.id')
          address=$(echo "$window" | jq -r '.address')
          hyprctl dispatch "hl.dsp.focus({ workspace = $workspace })"
          hyprctl dispatch "hl.dsp.focus({ window = { address = '$address' } })"
      else
          discord &
          disown
      fi
    '';
  };
in

{
  options.myModules.discord.enable = lib.mkEnableOption "Discord";

  config = lib.mkIf config.myModules.discord.enable {
    home.packages = [
      pkgs.discord
      discord-toggle
    ];
  };
}
