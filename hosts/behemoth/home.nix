{ pkgs, config, ... }:

{
	imports = [
		./../../modules/home/default.nix
	];

	home.username = "svenski";
	home.homeDirectory = "/home/svenski";
	home.stateVersion = "26.05";
	home.sessionVariables = {
        GTK_THEME = "adw-gtk3-dark";
    };

	gtk = {
        enable = true;
        theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
        };
    };

	# Host specific Hyprland settings
	myModules.hypr.singleWindowAspectRatio = "14 16";
	myModules.hypr.sensitivity = -0.50;
	myModules.hypr.workspaceMonitors = [
		{ id = 1; monitor = "DP-3"; }
		{ id = 2; monitor = "DP-1"; }
		{ id = 3; monitor = "DP-1"; }
		{ id = 4; monitor = "DP-1"; }
		{ id = 5; monitor = "DP-2"; }
	];
	myModules.hypr.monitors = [
		{
			output = "DP-1";
			mode = "3840x2160@240.02";
			position = "1440x560";
			scale = 1.5;
			bitdepth = 10;
		}
		{
			output = "DP-2";
			mode = "2560x1440@143.97";
			position = "4000x0";
			scale = 1.0;
			transform = 1;
		}
		{
			output = "DP-3";
			mode = "2560x1440@143.97";
			position = "0x0";
			scale = 1.0;
			transform = 3;
		}
	];
	
	# Applications (configured)
	myModules.applications.enable = true;

	# Config
	myModules.xdg.enable = true;
	myModules.zsh.enable = true;

	# Defaults (not configured)
    myModules.defaultApps.enable = true;
	myModules.defaultUtils.enable = true;
	
	# Desktop environment
	myModules.desktop.enable = true;
	myModules.waybar.enable = false;

	# Dev environment
	myModules.direnv.enable = true;

	# Scripts
	myModules.scripts.screenshot.enable = true;

	# Services
	myModules.services.enable = true;
	
	
}
