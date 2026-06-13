{
  description = "Hyprland on Nixos";
    
  inputs =  {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };	
  };

  outputs = {nixpkgs, home-manager, ...}: {
    nixosConfigurations.beelzebub = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
        modules = [
	  ./hosts/beelzebub/configuration.nix
	  home-manager.nixosModules.home-manager
	  {
            home-manager = {
	      useGlobalPkgs = true;
	      useUserPackages = true;
	      users.svenski = import ./home.nix;
	      backupFileExtension = "backup";
            };
	  }
	];
      };
    };
}
