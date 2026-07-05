{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = {
    # On first activation, set Nord as the default theme if none is active
    home.activation.setDefaultTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -f "$HOME/.local/state/theme/active-theme" ]; then
          mkdir -p "$HOME/.local/state/theme"
          $DRY_RUN_CMD ${pkgs.coreutils}/bin/ln -sfn \
              "$HOME/.config/themes/nord" \
              "$HOME/.local/state/theme/current"
          $DRY_RUN_CMD echo "nord" > "$HOME/.local/state/theme/active-theme"
      fi
    '';
  };
}
