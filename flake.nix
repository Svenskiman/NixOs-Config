{
  description = "Svenskis NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lmstudio = {
      url = "github:Daaboulex/lmstudio-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      walker,
      silentSDDM,
      flake-compat,
      sops-nix,
      lazyvim,
      hermes-agent,
      lmstudio,
      ...
    }@inputs:

    let
      hyprland-preview-share-picker =
        (import flake-compat {
          src = fetchGit {
            url = "https://github.com/WhySoBad/hyprland-preview-share-picker.git";
            rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
            submodules = true;
          };
        }).defaultNix;
    in

    {
      nixosConfigurations = {

        # Laptop
        beelzebub = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/beelzebub/configuration.nix
            home-manager.nixosModules.home-manager
            silentSDDM.nixosModules.default
            sops-nix.nixosModules.sops
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.svenski = import ./hosts/beelzebub/home.nix;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs hyprland-preview-share-picker; };
                sharedModules = [ walker.homeManagerModules.default ];
              };
            }
          ];
        };

        # Desktop
        behemoth = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = [ lmstudio.overlays.default ]; }
            ./hosts/behemoth/configuration.nix
            home-manager.nixosModules.default
            silentSDDM.nixosModules.default
            sops-nix.nixosModules.sops
            hermes-agent.nixosModules.default
            lmstudio.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.svenski = import ./hosts/behemoth/home.nix;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs hyprland-preview-share-picker; };
                sharedModules = [
                  walker.homeManagerModules.default
                  lazyvim.homeManagerModules.default
                ];
              };
            }
          ];
        };

        # Server
        hyperion = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/hyperion/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.sops
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.shrike = import ./hosts/hyperion/home.nix;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs hyprland-preview-share-picker; };
              };
            }
          ];
        };

      };
    };
}
