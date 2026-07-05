{ lib, config, ... }:

let
  makeBtopTheme = theme: ''
    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="${theme.colors.background}"

    # Main text color
    theme[main_fg]="${theme.colors.foreground}"

    # Title color for boxes
    theme[title]="${theme.colors.foreground}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${theme.colors.accent}"

    # Background color of selected item in processes box
    theme[selected_bg]="${theme.colors.color8}"

    # Foreground color of selected item in processes box
    theme[selected_fg]="${theme.colors.accent}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${theme.colors.color8}"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="${theme.colors.foreground}"

    # Background color of the percentage meters
    theme[meter_bg]="${theme.colors.color8}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="${theme.colors.foreground}"

    # CPU, Memory, Network, Proc box outline colors
    theme[cpu_box]="${theme.colors.color5}"
    theme[mem_box]="${theme.colors.color2}"
    theme[net_box]="${theme.colors.color1}"
    theme[proc_box]="${theme.colors.accent}"

    # Box divider line and small boxes line color
    theme[div_line]="${theme.colors.color8}"

    # Temperature graph color (Green -> Yellow -> Red)
    theme[temp_start]="${theme.colors.color2}"
    theme[temp_mid]="${theme.colors.color3}"
    theme[temp_end]="${theme.colors.color1}"

    # CPU graph colors
    theme[cpu_start]="${theme.colors.color6}"
    theme[cpu_mid]="${theme.colors.color4}"
    theme[cpu_end]="${theme.colors.color5}"

    # Mem/Disk free meter
    theme[free_start]="${theme.colors.color5}"
    theme[free_mid]="${theme.colors.color4}"
    theme[free_end]="${theme.colors.color6}"

    # Mem/Disk cached meter
    theme[cached_start]="${theme.colors.color4}"
    theme[cached_mid]="${theme.colors.color6}"
    theme[cached_end]="${theme.colors.color5}"

    # Mem/Disk available meter
    theme[available_start]="${theme.colors.color3}"
    theme[available_mid]="${theme.colors.color1}"
    theme[available_end]="${theme.colors.color1}"

    # Mem/Disk used meter
    theme[used_start]="${theme.colors.color2}"
    theme[used_mid]="${theme.colors.color6}"
    theme[used_end]="${theme.colors.color4}"

    # Download graph colors
    theme[download_start]="${theme.colors.color3}"
    theme[download_mid]="${theme.colors.color1}"
    theme[download_end]="${theme.colors.color1}"

    # Upload graph colors
    theme[upload_start]="${theme.colors.color2}"
    theme[upload_mid]="${theme.colors.color6}"
    theme[upload_end]="${theme.colors.color4}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="${theme.colors.color6}"
    theme[process_mid]="${theme.colors.color4}"
    theme[process_end]="${theme.colors.color5}"
  '';

  themeFiles = lib.listToAttrs (
    map (theme: {
      name = "themes/${theme.name}/btop.theme";
      value = {
        text = makeBtopTheme theme;
      };
    }) config.myModules.themes.definitions
  );
in

{
  config = lib.mkIf config.myModules.btop.enable {
    xdg.configFile = themeFiles;
  };
}
