{ pkgs, inputs', ... }:

let
nvim = inputs'.nixvim.legacyPackages.makeNixvim {
  globals.mapleader = " ";

  plugins = {
    telescope.enable = true;
    treesitter.enable = true;
    tmux-navigator.enable = true;

    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        clangd.enable = true;
        clangd.cmd = [
          "--compile-commands-dir=build"
        ];
        ts_ls.enable = true;
        nixd.enable = true;
        roslyn_ls.enable = true;
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
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };

  colorschemes.catppuccin = {
    enable = true;

    settings = {
      flavour = "mocha"; # latte, frappe, macchiato, mocha
      transparent_background = true;

        custom_highlights = ''
        function(colors)
        return {
          LineNr = { fg = "#AAAAAA", bg = "NONE", bold = false },
          CursorLineNr = { fg = "#AAAAAA", bg = "NONE", bold = true },
        }
      end
        '';
    };
  };

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
  {
    mode = "n";
    key = "<leader>T";
    action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    options = {
      desc = "Show diagnostic [E]rror in float";
      silent = true;
    };
  }
  ];

  opts = {
    title = true;
    titlestring = "%t";
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

in{
  packages.nvim = nvim;

  devShells.nvim = pkgs.mkShell {
    buildInputs = [ nvim ];
    shellHook = ''
      exec nvim
    '';
  };
}
