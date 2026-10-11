{
  description = "Master Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
 
    nixvim.url = "github:nix-community/nixvim";
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
          packages = [
            
          ];
          buildInputs = [ 
            self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
            self.packages.${pkgs.stdenv.hostPlatform.system}.tmux
            pkgs.git
          ];

          shellHook = ''
            alias la="ls -la"
            alias gl="git log"
            alias cls="clear"

            PS1='\[\e[38;5;33;1m\]\u\[\e[0m\] \[\e[38;5;51;1;3m\]\W\[\e[0m\] \[\e[38;5;214m\]#\[\e[0m\] '
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
