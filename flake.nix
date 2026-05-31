{
  description = "Tom's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ghostty,
    alejandra,
    helium,
    vicinae,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/thinkpad/default.nix
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [alejandra.packages.${system}.default];
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.thirst = import ./modules/home/default.nix;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.sharedModules = [
              vicinae.homeManagerModules.default
              {home.enableNixpkgsReleaseCheck = false;}
            ];
          }
        ];
      };
    };
  };
}
