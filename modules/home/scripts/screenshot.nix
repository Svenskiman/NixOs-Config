{
  pkgs,
  lib,
  config,
  ...
}:

# Screenshot script shamelessly stolen from Omarchy
# https://github.com/basecamp/omarchy/blob/df4ffe99/bin/omarchy-capture-screenshot

let
  # Base screenshots directory - should always exist if xdg.nix is enabled
  screenshotDir = "$HOME/Pictures/Screenshots";

  # Sets up the output path and creates the date subdirectory if needed
  setup_output = ''
    DATE_DIR="${screenshotDir}/$(date +%Y-%m-%d)"
    FILENAME="screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"
    OUTPUT="$DATE_DIR/$FILENAME"
    mkdir -p "$DATE_DIR"
  '';

  # Builds a list of selectable regions from the active workspace:
  # includes the focused monitor and all visible windows.
  # jq_monitor_geo handles portrait/rotated displays via the transform field.
  get_rectangles = ''
    get_rectangles() {
        local jq_monitor_geo='
            def format_geo:
                .x as $x | .y as $y |
                (.width / .scale | floor) as $w |
                (.height / .scale | floor) as $h |
                .transform as $t |
                if $t == 1 or $t == 3 then
                    "\($x),\($y) \($h)x\($w)"
                else
                    "\($x),\($y) \($w)x\($h)"
                end;
        '
        local active_workspace
        active_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')

        # Output monitor geometry for the active workspace
        hyprctl monitors -j | jq -r --arg ws "$active_workspace" \
            "$jq_monitor_geo .[] | select(.activeWorkspace.id == (\$ws | tonumber)) | format_geo"

        # Output all window geometries on the active workspace
        hyprctl clients -j | jq -r --arg ws "$active_workspace" \
            '.[] | select(.workspace.id == ($ws | tonumber)) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
    }
  '';

  # Handles the interactive selection:
  # - Spawns hyprpicker for the freeze overlay
  # - Passes window/monitor rectangles to slurp for region highlighting
  # - Smart snap: if selection area < 20px (i.e. a click not a drag),
  #   snaps to whichever window/monitor contains the click point
  do_selection = ''
    # Kill hyprpicker on exit regardless of how the script ends
    cleanup_freeze() {
        [[ -n $PID ]] && kill $PID 2>/dev/null
    }
    trap cleanup_freeze EXIT

    RECTS=$(get_rectangles)
    hyprpicker -r -z >/dev/null 2>&1 &
    PID=$!
    sleep 0.1

    SELECTION=$(echo "$RECTS" | slurp 2>/dev/null)

    # Smart snap logic
    if [[ $SELECTION =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]]; then
        if (( BASH_REMATCH[3] * BASH_REMATCH[4] < 20 )); then
            click_x="''${BASH_REMATCH[1]}"
            click_y="''${BASH_REMATCH[2]}"

            # Find which rectangle contains the click point
            while IFS= read -r rect; do
                if [[ $rect =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+) ]]; then
                    rect_x="''${BASH_REMATCH[1]}"
                    rect_y="''${BASH_REMATCH[2]}"
                    rect_width="''${BASH_REMATCH[3]}"
                    rect_height="''${BASH_REMATCH[4]}"

                    if (( click_x >= rect_x && click_x < rect_x + rect_width && click_y >= rect_y && click_y < rect_y + rect_height )); then
                        SELECTION="''${rect_x},''${rect_y} ''${rect_width}x''${rect_height}"
                        break
                    fi
                fi
            done <<<"$RECTS"
        fi
    fi

    # Exit cleanly if selection was cancelled (e.g. user pressed Escape)
    [[ -z $SELECTION ]] && exit 0
  '';

  # Plain capture: saves to file and copies to clipboard.
  # Notification dismisses after 2 seconds — clicking it opens the file in satty.
  capture_script = pkgs.writeShellApplication {
    name = "capture-screenshot";
    checkPhase = "";
    runtimeInputs = [
      pkgs.grim
      pkgs.slurp
      pkgs.jq
      pkgs.hyprpicker
      pkgs.libnotify
      pkgs.wl-clipboard
      pkgs.satty
    ];
    text = ''
      # Kill any existing slurp session before starting a new one
      pkill slurp && exit 0

      ${setup_output}
      ${get_rectangles}
      ${do_selection}

      grim -g "$SELECTION" "$OUTPUT" || exit 1
      wl-copy <"$OUTPUT"

      # Notify with clickable action to open in satty
      (
          ACTION=$(notify-send "Screenshot saved" "Saved to $OUTPUT" -t 2000 -i "$OUTPUT" -A "default=edit")
          [[ $ACTION == "default" ]] && satty \
              --filename "$OUTPUT" \
              --output-filename "$OUTPUT" \
              --early-exit \
              --actions-on-enter save-to-clipboard \
              --save-after-copy \
              --copy-command 'wl-copy'
      ) &
    '';
  };

  # Annotate capture: kills freeze before opening satty so screen unfreezes.
  capture_annotate_script = pkgs.writeShellApplication {
    name = "capture-screenshot-annotate";
    checkPhase = "";
    runtimeInputs = [
      pkgs.grim
      pkgs.slurp
      pkgs.jq
      pkgs.hyprpicker
      pkgs.satty
      pkgs.libnotify
      pkgs.wl-clipboard
    ];
    text = ''
      # Kill any existing slurp session before starting a new one
      pkill slurp && exit 0

      ${setup_output}
      ${get_rectangles}
      ${do_selection}

      # Capture to temp file first so we can kill the freeze before satty opens
      TMPFILE=$(mktemp /tmp/screenshot-XXXXXX.png)
      grim -g "$SELECTION" "$TMPFILE" || exit 1

      # Unfreeze screen before opening satty
      kill $PID 2>/dev/null

      # Open satty with the temp file, save to final output path
      satty \
          --filename "$TMPFILE" \
          --output-filename "$OUTPUT" \
          --early-exit \
          --actions-on-enter save-to-clipboard \
          --save-after-copy \
          --copy-command 'wl-copy'

      rm -f "$TMPFILE"
    '';
  };
in

{
  options = {
    myModules.scripts.screenshot.enable = lib.mkEnableOption "Screenshot scripts";
  };

  config = lib.mkIf config.myModules.scripts.screenshot.enable {
    home.packages = [
      capture_script
      capture_annotate_script
    ];
  };
}
