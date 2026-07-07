{ pkgs, nixvim, ... }:

nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvim {
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
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };

  colorschemes.catppuccin = {
    enable = true;

    settings = {
      flavour = "mocha"; # latte, frappe, macchiato, mocha

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
    number = true;        
    relativenumber = true; 

    clipboard = [ "unnamedplus" ];

    shiftwidth = 2;        
    tabstop = 2;           
    expandtab = true;      
    smartindent = true;    
    wrap = false;          
  };
}
