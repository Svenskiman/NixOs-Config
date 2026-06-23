{
    description = "Svenskis NixOS Config";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            # Use my packages
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # For configuring walker with home manager
        walker = {
            url = "github:abenz1267/walker";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # For lazy SDDM login screen styling
        silentSDDM = {
            url = "github:uiriansan/SilentSDDM";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {nixpkgs, home-manager, walker, silentSDDM, ...}: {
        nixosConfigurations.beelzebub = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            # Load my stuff
            modules = [
                ./hosts/beelzebub/configuration.nix
                home-manager.nixosModules.home-manager
                silentSDDM.nixosModules.default
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.svenski = import ./hosts/beelzebub/home.nix;
                        backupFileExtension = "backup";
                        sharedModules = [
                            walker.homeManagerModules.default
                        ];
                    };
                }
            ];
        };
    };
}