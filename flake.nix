{
   description = "My first flake";
	
	inputs = {
 	 nixpkgs.url = "nixpkgs/nixos-unstable";
	 chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
	 hyprland.url = "github:hyprwm/Hyprland";
	};
 
	outputs = {self, nixpkgs, chaotic, ... } @ inputs:
	let 
	  lib = nixpkgs.lib;
	in {
	  nixosConfigurations = {
	   nixos = lib.nixosSystem {
	    system = "x86_64-linux";
	    specialArgs = { inherit inputs; };
	    modules = [ 
	    ./configuration.nix
	    chaotic.nixosModules.default
		
	    ];

	   };

	  };

	};
    
    }
