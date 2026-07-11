# NixOS Config

A multi-host NixOS flake managing a laptop, desktop, and home server — all running NixOS unstable with Home Manager and a shared module system.

---

## Hosts

### Behemoth - Desktop
Primary desktop with multiple monitors. Local AI stack running of the GPU using llama-cpp and Hermes.

### Beelzebub - Laptop
ASUS Zenbook (AMD x86_64). 

### Hyperion — Server

---

## File Structure

```
.
├── flake.nix                    # Entry point — defines all three hosts and their inputs
├── flake.lock
├── .sops.yaml                   # Age key configuration for sops-nix
│
├── hosts/
│   ├── beelzebub/
│   │   ├── configuration.nix    # System config for the laptop
│   │   ├── home.nix             # Home Manager config for svenski on the laptop
│   │   ├── hardware-configuration.nix
│   │   └── secrets.yaml
│   ├── behemoth/
│   │   ├── configuration.nix    # System config for the desktop
│   │   ├── home.nix             # Home Manager config for svenski on the desktop
│   │   ├── hardware-configuration.nix
│   │   └── secrets.yaml
│   └── hyperion/
│       ├── configuration.nix    # System config for the server
│       ├── home.nix             # Minimal home for shrike (zsh + xdg only)
│       ├── hardware-configuration.nix
│       └── secrets.yaml
│
├── modules/
│   ├── system/                  # NixOS system-level modules
│   │   ├── default.nix          # Imports everything below
│   │   ├── nix-settings.nix
│   │   ├── fonts.nix
│   │   ├── users.nix            # Defines users: svenski and shrike
│   │   ├── secrets.nix
│   │   ├── boot/
│   │   ├── hardware/
│   │   ├── networking/
│   │   │   ├── networking.nix   # systemd-networkd + iwd
│   │   │   └── vpn.nix          # Mullvad VPN
│   │   ├── services/
│   │   │   ├── audio.nix
│   │   │   ├── bluetooth.nix (via hardware/)
│   │   │   ├── docker.nix
│   │   │   ├── tailscale.nix
│   │   │   ├── steam.nix
│   │   │   ├── hyprlock.nix     # PAM service for Hyprlock
│   │   │   ├── display-manager.nix
│   │   │   ├── portals.nix
│   │   │   └── ai/
│   │   │       ├── model.nix    # Shared AI model options (hfRepo, context, sampling)
│   │   │       ├── llama-cpp.nix
│   │   │       ├── hermes.nix   # Hermes agent CLI
│   │   │       ├── searxng.nix  # SearXNG Docker container
│   │   │       └── honcho.nix   # Honcho memory stack (Postgres + Redis + API + Deriver)
│   │   └── servers/
│   │       └── games/
│   │           ├── minecraft.nix
│   │           ├── valheim.nix
│   │           └── palworld.nix
│   │
│   └── home/                    # Home Manager modules
│       ├── default.nix          # Imports all subdirectories below
│       ├── apps/                # Individually configured apps
│       │   ├── alacritty.nix
│       │   ├── btop.nix
│       │   ├── discord.nix
│       │   ├── evince.nix
│       │   ├── imv.nix
│       │   ├── keepassxc.nix
│       │   ├── nautilus.nix
│       │   ├── onlyoffice.nix
│       │   └── games/
│       ├── config/              # Core user settings
│       │   ├── settings.nix     # Bundle options (applications, desktop, services)
│       │   ├── xdg.nix          # User dirs + desktop entry overrides
│       │   └── zsh.nix
│       ├── defaults/            # Unconfigured packages
│       │   ├── default-apps.nix 
│       │   └── default-utils.nix
│       ├── desktop/             # Desktop environment
│       │   ├── hyprland/        # Hyprland config split across bindings, monitors,
│       │   │                    #   windowrules, look & feel, workspaces, etc.
│       │   ├── eww/             # EWW bar + dropdown
│       │   ├── waybar/          # Waybar alternative
│       │   └── walker/          # Walker launcher config
│       ├── dev/
│       │   ├── direnv.nix
│       │   ├── neovim.nix       # LazyVim via lazyvim-nix flake
│       │   └── templates/       # Reusable devenv flakes (e.g. Python)
│       ├── patches/
│       │   └── audio.nix        # Zenbook mic boost fix
│       ├── scripts/             
│       │   ├── ai-local.nix     # ai-start / ai-stop / ai-status
│       │   ├── screenshot.nix   # grim + slurp + satty
│       │   ├── theme-switcher.nix
│       │   ├── clamshell.nix
│       │   ├── waybar-media.nix
│       │   └── eww/             # EWW-specific helper scripts
│       ├── services/
│       │   ├── portals.nix
│       │   ├── dropbox.nix
│       │   ├── wallpaper.nix
│       │   ├── hyprlock.nix
│       │   ├── hypridle.nix
│       │   └── swayosd/
│       └── themes/              # Theme system
│           ├── default.nix      # Defines themeType + imports all targets
│           ├── first-boot.nix
│           ├── definitions/     # Nord, Gruvbox, Everforest, Silent Hill, Nocturne
│           └── targets/         # Per-app colour file generators (eww, waybar,
│                                #   hyprland, mako, walker, alacritty, btop,
│                                #   swayosd, vscode, hyprlock, neovim…)
│
└── assets/
    └── icons/                   # SVGs and PNGs used in EWW
```

---

## Module Design

Everything is driven by `myModules.*` options rather than direct NixOS settings. Modules are opt-in via `lib.mkEnableOption` and composed at the host level, keeping `hosts/*/configuration.nix` and `hosts/*/home.nix` as thin declaration files.

A handful of **bundle options** (`myModules.applications.enable`, `myModules.desktop.enable`, `myModules.services.enable`) group related sub-modules with `lib.mkDefault` so they can be individually overridden — e.g. both hosts set `myModules.waybar.enable = false` to use EWW instead.

The **theme system** (`modules/home/themes/`) defines a structured `themeType` and generates per-app colour files at build time. Each target module writes CSS variables or config snippets into `~/.config/themes/<name>/`, and a `theme-switcher` script symlinks the active one to `~/.local/state/theme/current/`. This means live theme changes don't require a rebuild.

The **AI stack** (`modules/system/services/ai/`) is fully modular: `model.nix` holds shared sampling parameters (HF repo, context length, temperature, etc.) that are referenced by `llama-cpp.nix`, `hermes.nix`, and `honcho.nix`, so changing the model in one place propagates everywhere.

---

## Flake Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | NixOS unstable |
| `home-manager` | User environment management |
| `sops-nix` | Secrets decryption at activation time |
| `walker` | Application launcher |
| `silentSDDM` | Minimal SDDM theme |
| `lazyvim` | LazyVim Neovim distribution |
| `hermes-agent` | NousResearch Hermes AI agent + NixOS module |
| `flake-compat` | Used to fetch hyprland-preview-share-picker |


