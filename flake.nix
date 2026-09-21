{
  description = "Master Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { pkgs, ... }: {
        imports = [
          ./modules/tmux/tmux.nix
          ./modules/nvim/nvim.nix
        ];

        devShells.default = pkgs.mkShell {
          name = "Main Dev Shell";
          buildInputs = [ 
            self.imports.${pkgs.stdenv.hostPlatform.system}.nvim
            self.imports.${pkgs.stdenv.hostPlatform.system}.tmux
          ];

          shellHook = ''
            echo "Terminal Dev Shell Active"
          '';
        };

        apps = {
          nvim = {
            type = "app";
            program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.nvim}/bin/nvim";
          };

          tmux = {
            type = "app";
            program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.tmux}/bin/tmux";
          };
        };
      };
    };
}
