{ config, lib, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./../../modules/system/default.nix
	];

	networking.hostName = "behemoth";

	# System modules
    myModules.networking.enable = true;
    myModules.vpn.mullvad.enable = true;
    myModules.docker.enable = true;
    myModules.audio.enable = true;
    myModules.bluetooth.enable = true;
    myModules.displayManager.sddm.enable = true;
    myModules.fonts.enable = true;
    myModules.hyprlock.enable = true;
	
	programs.zsh.enable = true;
	programs.dconf.enable = true;

	time.timeZone = "Europe/London";

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		withUWSM = true;
	};

	# System trash
    services.gvfs.enable = true;

	system.stateVersion = "26.05";
}
