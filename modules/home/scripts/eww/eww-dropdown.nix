{ pkgs, lib, config, ... }:

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
        runtimeInputs = [ pkgs.gawk pkgs.jq pkgs.coreutils ];
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
        runtimeInputs = [ pkgs.gawk pkgs.jq ];
        text = ''
            usage=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%d", 100*(t-a)/t}' /proc/meminfo)
            jq -nc --argjson usage "$usage" '{usage: $usage}'
        '';
    };

    eww-gpu-status = pkgs.writeShellApplication {
        name = "eww-gpu-status";
        runtimeInputs = [ pkgs.jq ];
        text = ''
            FILE="/sys/class/drm/card0/device/gpu_busy_percent"
            if [ -r "$FILE" ]; then
                usage=$(cat "$FILE")
                jq -nc --argjson usage "$usage" '{available: true, usage: $usage}'
            else
                jq -nc '{available: false, usage: 0}'
            fi
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