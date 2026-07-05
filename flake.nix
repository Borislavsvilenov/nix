{
  description = "Nix Darwin Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew, home-manager, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "x86_64" ];

      perSystem = { pkgs, ... }: {
        packages.nvim = import ./modules/nvim/default.nix {
          inherit pkgs;
          nixvim = inputs.nixvim;
        };

        devShells.default = pkgs.mkShell {
          name = "Main Dev Shell";
          buildInputs = [ 
            self.packages.${pkgs.stdenv.hostPlatform.system}.nvim 
          ];

          shellHook = ''
            echo "Terminal Dev Shell Active (C/C++)"
          '';
        };

        apps.nvim = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.nvim}/bin/nvim";
        };
      };

      flake = {
        darwinConfigurations."samson" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs self; };
          modules = [
            ./configs/Darwin.nix
            nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "samson";
                };
              }

            home-manager.darwinModules.home-manager
            {
              users.users.samson.home = "/Users/samson";
              home-manager.extraSpecialArgs = { inherit self; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.samson = ./home.nix;
            }
          ];
        };
      };
    };
}
