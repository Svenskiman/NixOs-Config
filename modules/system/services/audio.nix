{ pkgs, lib, config, ... }:

{
    options = {
        myModules.audio.enable = lib.mkEnableOption "Enables Pipewire audio";
    };

    config = lib.mkIf config.myModules.audio.enable {
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

        environment.systemPackages = [
            pkgs.pulseaudio # pactl/pacmd CLI tools for inspecting PipeWire's Pulse-compat layer
            pkgs.alsa-utils # amixer/alsamixer for inspecting raw ALSA mixer controls (e.g. Mic Boost)
        ];
    };
}