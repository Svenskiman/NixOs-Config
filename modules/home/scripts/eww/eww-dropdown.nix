{
  pkgs,
  lib,
  config,
  ...
}:

let
  eww-dropdown-toggle = pkgs.writeShellApplication {
    name = "eww-dropdown-toggle";
    runtimeInputs = [ pkgs.eww ];
    text = ''
      if eww active-windows | grep -q "dropdown"; then
          eww close dropdown
      else
          eww open dropdown
      fi
    '';
  };

  eww-dropdown-toggle-centered = pkgs.writeShellApplication {
    name = "eww-dropdown-toggle-centered";
    runtimeInputs = [ pkgs.eww ];
    text = ''
      if eww active-windows | grep -q "dropdown-centered"; then
          eww close dropdown-centered
      else
          eww open dropdown-centered
      fi
    '';
  };

  eww-cpu-status = pkgs.writeShellApplication {
    name = "eww-cpu-status";
    runtimeInputs = [
      pkgs.gawk
      pkgs.jq
      pkgs.coreutils
    ];
    text = ''
      read -r _ u1 n1 s1 i1 _ < /proc/stat
      sleep 0.5
      read -r _ u2 n2 s2 i2 _ < /proc/stat
      busy1=$((u1+n1+s1)); total1=$((u1+n1+s1+i1))
      busy2=$((u2+n2+s2)); total2=$((u2+n2+s2+i2))
      usage=$(awk -v b1="$busy1" -v t1="$total1" -v b2="$busy2" -v t2="$total2" \
          'BEGIN { printf "%d", 100 * (b2-b1) / (t2-t1) }')
      jq -nc --argjson usage "$usage" '{usage: $usage}'
    '';
  };

  eww-ram-status = pkgs.writeShellApplication {
    name = "eww-ram-status";
    runtimeInputs = [
      pkgs.gawk
      pkgs.jq
    ];
    text = ''
      usage=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%d", 100*(t-a)/t}' /proc/meminfo)
      jq -nc --argjson usage "$usage" '{usage: $usage}'
    '';
  };

  eww-gpu-status = pkgs.writeShellApplication {
    name = "eww-gpu-status";
    runtimeInputs = [
      pkgs.rocmPackages.rocm-smi
      pkgs.gawk
      pkgs.jq
    ];
    text = ''
      raw=$(rocm-smi --showmeminfo vram -u --json 2>/dev/null) || true

      if [ -z "$raw" ]; then
        jq -nc '{available: false, usage: 0, vram_used_mb: 0, vram_total_mb: 0, vram_percent: 0}'
        exit 0
      fi

      usage=$(echo "$raw" | jq -r '.card0["GPU use (%)"]')
      vram_total_b=$(echo "$raw" | jq -r '.card0["VRAM Total Memory (B)"]')
      vram_used_b=$(echo "$raw" | jq -r '.card0["VRAM Total Used Memory (B)"]')

      vram_total_mb=$(awk -v v="$vram_total_b" 'BEGIN { printf "%d", v / 1024 / 1024 }')
      vram_used_mb=$(awk -v v="$vram_used_b" 'BEGIN { printf "%d", v / 1024 / 1024 }')
      vram_percent=$(awk -v u="$vram_used_mb" -v t="$vram_total_mb" 'BEGIN { printf "%d", 100 * u / t }')

      jq -nc \
        --argjson usage "$usage" \
        --argjson vram_used_mb "$vram_used_mb" \
        --argjson vram_total_mb "$vram_total_mb" \
        --argjson vram_percent "$vram_percent" \
        '{available: true, usage: $usage, vram_used_mb: $vram_used_mb, vram_total_mb: $vram_total_mb, vram_percent: $vram_percent}'
    '';
  };
in

{
  config = lib.mkIf config.myModules.eww.enable {
    home.packages = [
      eww-dropdown-toggle
      eww-dropdown-toggle-centered
      eww-cpu-status
      eww-ram-status
      eww-gpu-status
    ];
  };
}
