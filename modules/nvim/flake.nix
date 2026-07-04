{
  description = "standalone neovim nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixvim, flake-utils, ... }@inputs: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        nvim = nixvim.legacyPackages.${system}.makeNixvim {
      
        globals.mapleader = " ";
        
        plugins = {
          telescope.enable = true;
          treesitter.enable = true;

          lsp = {
            enable = true;
            servers = {
              lua_ls.enable = true;
              clangd.enable = true;
              ts_ls.enable = true;
              nixd.enable = true;
            };

            keymaps.lspBuf = {
              "gd" = "definition";
              "gD" = "declaration";
              "K" = "hover";
              "gi" = "implementation";
              "gr" = "references";
              "<leader>rn" = "rename";
              "<leader>ca" = "code_action";
            };


          };

          cmp = {
            enable = true;
            settings = {
              autoEnableSources = true;
              sources = [
                { name = "nvim_lsp"; }
                { name = "path"; }
                { name = "buffer"; }
              ];

              mapping = {
                "<C-f>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                "<C-d>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
              };
            };
          };
        };

        colorschemes.catppuccin.enable = true;

        keymaps = [
        {
          mode = "n";
          key = "<leader>e";
          action = ":Ex<CR>";
          options = {
            silent = true;
            desc = "open explorer";
          };
        }
        {
          mode = "n";
          key = "<leader>ff";
          action.__raw = "function() require('telescope.builtin').find_files() end";
          options = {
            desc = "Telescope Find Files";
          };
        }
        {
          mode = "n";
          key = "<leader>=";
          action = "gg=G``"; 
          options = {
            silent = true;
            desc = "Auto-align/format entire file";
          };
        }
        ];

        opts = {
          number = true;        
          relativenumber = true; 

          clipboard = [ "unnamedplus" ];

          shiftwidth = 2;        
          tabstop = 2;           
          expandtab = true;      
          smartindent = true;    
          wrap = false;          
        };
        };
        in
        {
          packages.default = nvim;
          devShells.default = pkgs.mkShell {
            name = "Terminal Dev Shell";

            buildInputs = [
              nvim
            ];

            shellHook = ''
              echo "Terminal Dev Shell Active (C/C++)"
              '';
          };
        }
        );
}
