{ pkgs, pkgs-unstable, config, ... }:
let
  cscope_maps-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "cscope_maps-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "dhananjaylatkar";
      repo = "cscope_maps.nvim";
      rev = "065fcdd059eb69d013a10d94846d20f1b8fd8ef6";
      sha256 = "sha256-xl9eDmBCOxJ0lNHDdnHxonHMn1Iz5lW/oUOdwoRknH4=";
    };
  };
  wf-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "wf-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "Cassin01";
      repo = "wf.nvim";
      rev = "fe5d94278f33446c3afdb34dac9f3a953907f720";
      sha256 = "sha256-QssI2cF4PjKT0TAo9CveKeLwcIN8DQl7loi77fiIoo4=";
    };
  };
in
{
  # home.packages = with pkgs; [
  # ];

  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };

  programs.neovim = {
    package = pkgs-unstable.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs-unstable; [
      cscope_maps-nvim
      # vimPlugins.cmp-tabnine
      # vimPlugins.copilot-vim
      vimPlugins.catppuccin-nvim
      vimPlugins.cmp-buffer
      vimPlugins.cmp-cmdline
      vimPlugins.cmp-git
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-nvim-lsp-document-symbol
      vimPlugins.cmp-nvim-lua
      vimPlugins.cmp-path
      vimPlugins.cmp_luasnip
      vimPlugins.comment-nvim
      vimPlugins.copilot-cmp
      vimPlugins.copilot-lua
      vimPlugins.fidget-nvim
      vimPlugins.firenvim
      vimPlugins.friendly-snippets
      vimPlugins.fzf-checkout-vim
      vimPlugins.fzf-vim
      vimPlugins.git-worktree-nvim
      vimPlugins.gitsigns-nvim
      vimPlugins.harpoon2
      vimPlugins.lsp-zero-nvim
      vimPlugins.lsp_extensions-nvim
      vimPlugins.lspkind-nvim
      vimPlugins.lspsaga-nvim
      vimPlugins.luasnip
      vimPlugins.markdown-preview-nvim
      vimPlugins.mason-lspconfig-nvim
      vimPlugins.mason-nvim
      vimPlugins.mason-tool-installer-nvim
      vimPlugins.neodev-nvim
      vimPlugins.nvim-cmp
      vimPlugins.nvim-fzf
      vimPlugins.nvim-lint
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-notify
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-treesitter-textobjects
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.nvim-web-devicons
      vimPlugins.oil-nvim
      vimPlugins.playground
      vimPlugins.plenary-nvim
      vimPlugins.project-nvim
      vimPlugins.rust-vim
      vimPlugins.telescope-fzf-native-nvim
      vimPlugins.telescope-nvim
      vimPlugins.undotree
      vimPlugins.vim-be-good
      vimPlugins.vim-clang-format
      vimPlugins.vim-fugitive
      vimPlugins.vim-go
      vimPlugins.vim-qml
      vimPlugins.vim-rhubarb
      vimPlugins.vim-sleuth
      vimPlugins.zen-mode-nvim
      wf-nvim
    ];

    extraPackages = with pkgs; [
      # tabnine
      neocmakelsp
      nixd
      cscope

      # languages
      jsonnet
      nodejs
      # python311Full
      # rustc
      marksman

      # language servers
      # gopls
      # haskell-language-server
      # jsonnet-language-server
      lua-language-server
      nil
      nodePackages."bash-language-server"
      nodePackages."diagnostic-languageserver"
      nodePackages."dockerfile-language-server-nodejs"
      nodePackages."pyright"
      # nodePackages."typescript"
      # nodePackages."typescript-language-server"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      # rust-analyzer
      terraform-ls

      # formatters
      # gofumpt
      # golines
      # nixpkgs-fmt
      # python310Packages.black
      # rustfmt

      # tools
      # cmake
      # cmake-language-server
      # gnumake
      # checkmake
      # cargo
      # gcc
      # llvmPackages.clang-unwrapped # c/c++ tools with clang-tools such as clangd
      # gdb
      # lldb
      # ghc
      # lazydocker
      # yarn
    ];
  };
}
