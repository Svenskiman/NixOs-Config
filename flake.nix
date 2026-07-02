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

        # Needed to import hyprland-preview-share-picker as a non-flake-input source,
        # https://github.com/NixOS/nix/issues/11275
        flake-compat.url = "github:edolstra/flake-compat";
    };

    outputs = {nixpkgs, home-manager, walker, silentSDDM, flake-compat, ...} @ inputs:
    let
        hyprland-preview-share-picker = (import flake-compat {
            src = builtins.fetchGit {
                url = "https://github.com/WhySoBad/hyprland-preview-share-picker.git";
                rev = "e2f30ff85486e557018523da45ccbc846e3a499c";
                submodules = true;
            };
        }).defaultNix;
    in
    {
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
                        extraSpecialArgs = { inherit inputs hyprland-preview-share-picker; };
                        sharedModules = [
                            walker.homeManagerModules.default
                        ];
                    };
                }
            ];
        };

	nixosConfigurations.behemoth = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			./hosts/behemoth/configuration.nix
			home-manager.nixosModules.default
			silentSDDM.nixosModules.default
			{
				home-manager = {
					useGlobalPkgs = true;
					useUserPackages = true;
					users.svenski = import ./hosts/behemoth/home.nix;
					backupFileExtension = "backup";
					extraSpecialArgs = { inherit inputs hyprland-preview-share-picker; };
					sharedModules = [
						walker.homeManagerModules.default
					];
				};

			}

		];
    	};
    };
}