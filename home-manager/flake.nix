{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = { 
      url = "github:nix-community/nixGL"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = inputs @ { self, nixpkgs, flake-utils, home-manager, fenix, nix-vscode-extensions, devshell, nixGL, ... }:
    let
      inherit (lib.my) mapToAttrSet mapToList mapToFlatSet mapHosts mapHome;

      system = "x86_64-linux";
      stateVersion = "22.11";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          (final: prev: {
            my = self.packages."${system}";
          })
          fenix.overlays.default
          nix-vscode-extensions.overlays.default
          devshell.overlays.default
        ];
      };

      # thx hlissner/dotfiles
      lib = nixpkgs.lib.extend
        (self: super: {
          my = import ./lib { inherit pkgs inputs; lib = self; };
          hm = home-manager.lib;
        });
    in
    {
      lib = lib.my;

      nixosModules = mapToAttrSet ./modules import;

      nixosConfigurations = mapHosts ./hosts {
        inherit system stateVersion;
        modules = [
          home-manager.nixosModules.home-manager
          {
            system.extraDependencies = mapToList ./shells (s: pkgs.callPackage s { inherit lib; });
          }
        ];
      };

      homeConfigurations = mapHome ./home {
        inherit system stateVersion;
        modules = [
        ];
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        shells = mapToFlatSet ./shells (s: pkgs.callPackage s { inherit lib; });
      in
      {
        devShells = shells;

        packages = mapToFlatSet ./packages (p: pkgs.callPackage p { }) // shells;
      }));
}
