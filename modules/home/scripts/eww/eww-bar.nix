{
  pkgs,
  lib,
  config,
  ...
}:

let
  # Streams live Hyprland workspace state to eww via deflisten.
  #
  # Emits one JSON line per update, shaped as:
  #   {"active": <id>, "occupied": [<id>, <id>, ...]}
  #
  # "active"   - the currently focused workspace ID
  # "occupied" - every workspace ID that currently has at least one window
  eww-workspace-listener = pkgs.writeShellApplication {
    name = "eww-workspace-listener";
    runtimeInputs = [
      pkgs.socat
      pkgs.hyprland
      pkgs.jq
    ];
    text = ''
      # Hyprland's event socket - emits plain-text lines like
      # "workspace>>3" any time something relevant happens.
      SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

      # Queries current Hyprland state directly (via hyprctl) and
      # prints it as a single JSON line.
      emit_state() {
          active=$(hyprctl activeworkspace -j | jq -c '.id')
          occupied=$(hyprctl workspaces -j | jq -c '[.[] | select(.windows > 0) | .id]')
          jq -nc --argjson active "$active" --argjson occupied "$occupied" \
              '{active: $active, occupied: $occupied}'
      }

      # Emit once immediately on startup
      emit_state

      # Then keep listening forever, re-emitting state whenever a
      # workspace-relevant event comes through the socket.
      socat -U - "UNIX-CONNECT:$SOCKET" | while read -r line; do
          case "$line" in
              workspace\>\>*|createworkspace\>\>*|destroyworkspace\>\>*|openwindow\>\>*|closewindow\>\>*|movewindow\>\>*)
                  emit_state
                  ;;
          esac
      done
    '';
  };

  # Polls the default audio sink's volume/mute state via wpctl.
  # Emits one JSON line: {"volume": <0-100>, "muted": true|false}
  eww-audio-status = pkgs.writeShellApplication {
    name = "eww-audio-status";
    runtimeInputs = [
      pkgs.wireplumber
      pkgs.jq
    ];
    text = ''
      status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
      raw=$(echo "$status" | awk '{print $2}')
      volume=$(awk -v v="$raw" 'BEGIN { printf "%d", v * 100 }')

      if echo "$status" | grep -q MUTED; then
          muted=true
      else
          muted=false
      fi

      jq -nc --argjson volume "$volume" --argjson muted "$muted" \
          '{volume: $volume, muted: $muted}'
    '';
  };

  # Polls Bluetooth power/connection state via bluetoothctl.
  # Emits one JSON line: {"powered": true|false, "connected": true|false}
  eww-bluetooth-status = pkgs.writeShellApplication {
    name = "eww-bluetooth-status";
    runtimeInputs = [
      pkgs.bluez
      pkgs.jq
      pkgs.gnugrep
    ];
    text = ''
      bt_show=$(timeout 3s bluetoothctl show 2>/dev/null || echo "")
      bt_info=$(timeout 3s bluetoothctl info 2>/dev/null || echo "")

      if echo "$bt_show" | grep -q "Powered: yes"; then
          powered=true
      else
          powered=false
      fi

      if echo "$bt_info" | grep -q "Connected: yes"; then
          connected=true
      else
          connected=false
      fi

      jq -nc --argjson powered "$powered" --argjson connected "$connected" \
          '{powered: $powered, connected: $connected}'
    '';
  };

  # Polls WiFi connection state via iwctl (iwd's CLI)
  # Emits one JSON line: {"connected": true|false, "signal": <0-100>}
  # Calculate signal strength using Microsoft WLAN_ASSOCIATION_ATTRIBUTES standard
  eww-network-status = pkgs.writeShellApplication {
    name = "eww-network-status";
    runtimeInputs = [
      pkgs.iwd
      pkgs.jq
      pkgs.gawk
      pkgs.gnused
    ];
    text = ''
      # iwctl emits ANSI colour codes even when piped. Strip them.
      strip_ansi() {
          sed -E 's/\x1b\[[0-9;]*[a-zA-Z]//g'
      }

      device=$(timeout 4s iwctl device list 2>/dev/null | strip_ansi | awk '/station/ {print $1; exit}')

      if [ -z "$device" ]; then
          jq -nc '{connected: false, signal: 0}'
          exit 0
      fi

      output=$(timeout 4s iwctl station "$device" show 2>/dev/null | strip_ansi)

      if echo "$output" | grep -q "State *connected"; then
          connected=true
          rssi=$(echo "$output" | awk '/RSSI/ {print $2; exit}')

          # Calculate signal strength
          signal=$(awk -v r="$rssi" 'BEGIN {
              pct = 2 * (r + 100)
              if (pct > 100) pct = 100
              if (pct < 0) pct = 0
              printf "%d", pct
          }')

      else
          connected=false
          signal=0
      fi

      jq -nc --argjson connected "$connected" --argjson signal "$signal" \
          '{connected: $connected, signal: $signal}'
    '';
  };

  # Polls battery capacity/charging state from sysfs.
  # Emits one JSON line: {"capacity": <0-100>, "charging": true|false}
  eww-battery-status = pkgs.writeShellApplication {
    name = "eww-battery-status";
    runtimeInputs = [ pkgs.jq ];
    text = ''
      bat_path=""
      for bat in /sys/class/power_supply/BAT*; do
          [ -d "$bat" ] && bat_path="$bat" && break
      done

      if [ -z "$bat_path" ]; then
          jq -nc '{capacity: 0, charging: false}'
          exit 0
      fi

      capacity=$(cat "$bat_path/capacity")
      status=$(cat "$bat_path/status")

      if [ "$status" = "Charging" ]; then
          charging=true
      else
          charging=false
      fi

      jq -nc --argjson capacity "$capacity" --argjson charging "$charging" \
          '{capacity: $capacity, charging: $charging}'
    '';
  };

  # Polls Dropbox sync state via `dropbox status`.
  # Emits one JSON line: {"status": "synced"|"syncing"|"paused"|"error"}
  eww-dropbox-status = pkgs.writeShellApplication {
    name = "eww-dropbox-status";
    runtimeInputs = [
      pkgs.dropbox-cli
      pkgs.jq
      pkgs.gnugrep
      pkgs.procps
    ];
    text = ''
      if ! pgrep -f "dropbox-lnx" >/dev/null 2>&1; then
          jq -nc '{status: "error"}'
          exit 0
      fi

      output=$(timeout 10 dropbox status 2>/dev/null || echo "")

      if echo "$output" | grep -qiE "up to date"; then
          status="synced"
      elif echo "$output" | grep -qiE "syncing|downloading|uploading|indexing|starting|connecting"; then
          status="syncing"
      elif echo "$output" | grep -qiE "paused"; then
          status="paused"
      else
          status="error"
      fi

      jq -nc --arg status "$status" '{status: $status}'
    '';
  };

  # Polls Discord process + voice state via pactl.
  #   - "off"  : discord not running
  #   - "on"   : running, no active mic-capture source-output (not in a call)
  #   - "call" : running, has an active source-output (in a voice call)
  eww-discord-status = pkgs.writeShellApplication {
    name = "eww-discord-status";
    runtimeInputs = [
      pkgs.pulseaudio
      pkgs.jq
      pkgs.procps
      pkgs.gawk
    ];
    text = ''
      if ! pgrep -f '/opt/Discord/' >/dev/null 2>&1; then
          jq -nc '{status: "off"}'
          exit 0
      fi

      # application.process.binary is ".Discord-wrapped" (Flatpak-style),
      # so match loosely on "discord" rather than an exact string.
       found=$(pactl list source-outputs | awk '
          BEGIN { IGNORECASE = 1 }
          /application\.process\.binary = / {
              if ($0 ~ /discord/) { print "yes"; exit }
          }
      ')

      if [ "$found" = "yes" ]; then
          jq -nc '{status: "call"}'
      else
          jq -nc '{status: "on"}'
      fi
    '';
  };

  # Polls Spotify playback state via playerctl.
  # Emits one JSON line: {"title": "...", "position": "m:ss", "length": "m:ss", "status": "Playing"|"Paused", "active": true|false}
  # Title takes priority — remaining characters filled with " - artist", truncated if needed.
  # Position and length are empty strings when nothing is playing.
  eww-spotify-status = pkgs.writeShellApplication {
    name = "eww-spotify-status";
    runtimeInputs = [
      pkgs.playerctl
      pkgs.jq
    ];
    text = ''

      MAX_CHARS=25 # Max characters before truncation
      PAD_TO=28 # Fixed display width

      output=$(playerctl --player=spotify metadata \
          --format '{{title}}§{{status}}§{{position}}§{{mpris:length}}§{{artist}}' 2>/dev/null || true)

      if [ -z "$output" ]; then
          jq -nc '{title: "Nothing playing...", position: "", length: "", status: "Paused", active: false}'
          exit 0
      fi

      IFS='§' read -r title status position length artist <<< "$output"

      # Build display string and have title take priority.
      if [ "''${#title}" -lt $MAX_CHARS ]; then
          remaining=$(( MAX_CHARS - ''${#title} ))
          suffix=" - $artist"
          if [ "''${#suffix}" -gt "$remaining" ]; then
              suffix="''${suffix:0:$remaining}..."
          fi
          display="$title$suffix"
      elif [ "''${#title}" -gt $MAX_CHARS ]; then
          display="''${title:0:$MAX_CHARS}..."
      else
          display="$title"
      fi

      while [ "''${#display}" -lt $PAD_TO ]; do
          display="$display "
      done

      to_timestamp() {
          local us=$1
          local total_seconds=$(( us / 1000000 ))
          local minutes=$(( total_seconds / 60 ))
          local seconds=$(( total_seconds % 60 ))
          printf "%d:%02d" "$minutes" "$seconds"
      }

      position_fmt=$(to_timestamp "$position")
      length_fmt=$(to_timestamp "$length")

      jq -nc \
          --arg title "$display" \
          --arg position "$position_fmt" \
          --arg length "$length_fmt" \
          --arg status "$status" \
          '{title: $title, position: $position, length: $length, status: $status, active: true}'
    '';
  };

  # Polls Mullvad VPN tunnel state via the mullvad CLI.
  # Emits one JSON line: {"status": "connected"|"connecting"|"blocked"|"disconnected"|"error"}
  eww-mullvad-status = pkgs.writeShellApplication {
    name = "eww-mullvad-status";
    runtimeInputs = [
      pkgs.mullvad
      pkgs.jq
    ];
    text = ''
      output=$(timeout 4s mullvad status 2>/dev/null || echo "")

      if echo "$output" | grep -q "^Connected"; then
          status="connected"
      elif echo "$output" | grep -q "^Connecting"; then
          status="connecting"
      elif echo "$output" | grep -q "^Blocked"; then
          status="blocked"
      elif echo "$output" | grep -q "^Disconnected"; then
          status="disconnected"
      else
          status="error"
      fi

      jq -nc --arg status "$status" '{status: $status}'
    '';
  };

  # Polls Docker daemon state via docker ps.
  # Emits one JSON line: {"status": "running"|"idle"|"error", "count": <n>}
  eww-docker-status = pkgs.writeShellApplication {
    name = "eww-docker-status";
    runtimeInputs = [
      pkgs.docker
      pkgs.jq
    ];
    text = ''
      if ! timeout 4s docker info >/dev/null 2>&1; then
          jq -nc '{status: "error", count: 0}'
          exit 0
      fi

      count=$(docker ps -q | wc -l)

      if [ "$count" -gt 0 ]; then
          status="running"
      else
          status="idle"
      fi

      jq -nc --argjson count "$count" --arg status "$status" \
          '{status: $status, count: $count}'
    '';
  };

  # Polls local AI stack status.
  # systemd services: all stopped → "off", some stopped → "red", all active then continue.
  # HTTP health checks: any endpoint unreachable → "red", all reachable → "green".
  # Emits one JSON line: {"status": "off"|"red"|"green"}
  eww-ai-status = pkgs.writeShellApplication {
    name = "eww-ai-status";
    runtimeInputs = [
      pkgs.systemd
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      services=(
        llama-swap
        llama-cpp-embed
        docker-searxng
        docker-honcho-db
        docker-honcho-redis
        docker-honcho-api
        docker-honcho-deriver
        docker-crawl4ai
      )

      total=''${#services[@]}
      count=0

      for svc in "''${services[@]}"; do
        systemctl is-active --quiet "$svc" && count=$((count + 1)) || true
      done

      if (( count == 0 )); then
        jq -nc '{status: "off"}'
        exit 0
      fi

      if (( count < total )); then
        jq -nc '{status: "red"}'
        exit 0
      fi

      endpoints=(
        "http://localhost:8080/health"
        "http://localhost:8081/health"
        "http://localhost:8000/health"
        "http://localhost:8123"
        "http://localhost:11235/health"
      )

      for url in "''${endpoints[@]}"; do
        if ! curl -sf --max-time 2 "$url" >/dev/null 2>&1; then
          jq -nc '{status: "red"}'
          exit 0
        fi
      done

      jq -nc '{status: "green"}'
    '';
  };

in

{
  # Disabled if eww is off
  config = lib.mkIf config.myModules.eww.enable {
    home.packages = [
      eww-workspace-listener
      eww-audio-status
      eww-bluetooth-status
      eww-network-status
      eww-battery-status
      eww-dropbox-status
      eww-discord-status
      eww-spotify-status
      eww-mullvad-status
      eww-docker-status
      eww-ai-status
    ];
  };
}
