{ config, lib, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./../../modules/system/default.nix
        ./../../modules/system/services/display-manager.nix
	];

	networking.hostName = "behemoth";

    myModules.gpu = "amd";

	# System modules
    myModules.boot.enable = true;
    myModules.plymouth.enable = true;

    myModules.networking.enable = true;
    myModules.vpn.mullvad.enable = true;
    myModules.docker.enable = true;
    myModules.audio.enable = true;
    myModules.bluetooth.enable = true;
    myModules.displayManager.sddm.enable = true;
    myModules.fonts.enable = true;
    myModules.hyprlock.enable = true;
    myModules.steam.enable = true;
	
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

	# Additional drives
    fileSystems."/mnt/2tb-ssd" = {
        device = "/dev/disk/by-uuid/2cc3d919-7a9a-4891-acd7-f7587cde6230";
        fsType = "ext4";
        options = [ "defaults" "noatime" "nofail" ];
    };

    fileSystems."/mnt/games" = {
        device = "/dev/disk/by-uuid/ed67dd4a-9c51-49b2-bcf2-f8ccbc658fb8";
        fsType = "ext4";
        options = [ "defaults" "noatime" ];
    };

    fileSystems."/mnt/4tb-hdd" = {
        device = "/dev/disk/by-uuid/ef6e43f2-34a5-46af-932f-c81c78bd1474";
        fsType = "ext4";
        options = [ "defaults" "noatime" "nofail" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
    };

	system.stateVersion = "26.05";
}
