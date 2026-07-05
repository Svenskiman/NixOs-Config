# Declarative ACP (alsa-card-profile) overrides.
# Each section below is a hardware-specific audio fix for a particular
# machine.
# Enable the relevant one(s) in that host's home.nix.
{ lib, config, ... }:

{
  options = {
    myModules.audioFixes.zenbookMicBoost.enable = lib.mkEnableOption "Forces Mic Boost off via ACP override (Zenbook UN5401QAB, ALC294)";

    # myModules.audioFixes.someOtherMachine.enable = lib.mkEnableOption "...";
  };

  config = lib.mkMerge [
    # ── Zenbook UN5401QAB ────────────────────────────────────────
    # Mic Boost defaults to max on the internal mic (ALC294),
    # causing static. ACP's Mic Boost element merges in a live
    # hardware-read volume rather than respecting a fixed default,
    # so the fix is forcing volume = zero directly on the element.
    (lib.mkIf config.myModules.audioFixes.zenbookMicBoost.enable {
      home.file.".config/alsa-card-profile/paths/analog-input-mic.conf".text = ''
        [General]
        priority = 87
        description-key = analog-input-microphone

        [Jack Mic]
        required-any = any

        [Jack Mic Phantom]
        required-any = any
        state.plugged = unknown
        state.unplugged = unknown

        [Jack Mic - Input]
        required-any = any

        [Element Capture]
        switch = mute
        volume = merge
        override-map.1 = all
        override-map.2 = all-left,all-right

        [Element Mic Boost]
        required-any = any
        switch = select
        volume = zero
        override-map.1 = all
        override-map.2 = all-left,all-right

        [Option Mic Boost:off]
        name = input-boost-off

        [Element Mic]
        required-any = any
        switch = mute
        volume = merge
        override-map.1 = all
        override-map.2 = all-left,all-right

        [Element Input Source]
        enumeration = select

        [Option Input Source:Mic]
        name = analog-input-microphone
        required-any = any

        [Element Capture Source]
        enumeration = select

        [Option Capture Source:Mic]
        name = analog-input-microphone
        required-any = any

        [Element PCM Capture Source]
        enumeration = select

        [Option PCM Capture Source:Mic]
        name = analog-input-microphone
        required-any = any

        [Option PCM Capture Source:Mic-In/Mic Array]
        name = analog-input-microphone
        required-any = any
      '';
    })
  ];
}
