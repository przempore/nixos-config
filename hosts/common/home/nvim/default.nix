{ pkgs, config, ... }:
let
  cscope_maps-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "cscope_maps-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "dhananjaylatkar";
      repo = "cscope_maps.nvim";
      rev = "c3922f1decbbcedca3aba5cd4534f397e5a903b4";
      sha256 = "sha256-FyQZ3zm8aXbfHh192Xw9LVVOsmz6O9h//0oLU9wBAms=";
    };
  };
  wf-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "wf-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "Cassin01";
      repo = "wf.nvim";
      rev = "01882d2a5e6dd4f45663a652a4b358cefbb97ce2";
      sha256 = "sha256-8PzsDPJXb8kpVus7b4Fon785j8JPTZM4fZ7PM5A67YU=";
    };
  };
  harpoon2 = pkgs.vimUtils.buildVimPlugin {
    name = "harpoon2";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "31701337377991c66eebb57ebd23ef01eb587352";
      sha256 = "sha256-dJDawg76OcMKaAtbvKdJmUrNp6TBA2NHJvupmGCvYEc=";
    };
  };
in
{
  home.packages = with pkgs; [
    # neovim
    tabnine
    neocmakelsp
    rnix-lsp
  ];

  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [
      cscope_maps-nvim
      wf-nvim
      vimPlugins.copilot-vim
      vimPlugins.vim-fugitive
      vimPlugins.vim-rhubarb
      vimPlugins.nvim-fzf
      vimPlugins.plenary-nvim
      vimPlugins.telescope-nvim
      vimPlugins.telescope-fzf-native-nvim
      vimPlugins.vim-qml
      vimPlugins.catppuccin-nvim
      vimPlugins.vim-be-good
      vimPlugins.cmp-git
      vimPlugins.git-worktree-nvim
      # vimPlugins.harpoon2
      harpoon2
      vimPlugins.gitsigns-nvim
      vimPlugins.fzf-checkout-vim
      vimPlugins.firenvim
      vimPlugins.fidget-nvim
      vimPlugins.neodev-nvim
      vimPlugins.lsp-zero-nvim
      vimPlugins.mason-tool-installer-nvim
      vimPlugins.mason-nvim
      vimPlugins.mason-lspconfig-nvim
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-cmp
      vimPlugins.cmp-buffer
      vimPlugins.cmp-path
      vimPlugins.cmp_luasnip
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-nvim-lua
      vimPlugins.luasnip
      vimPlugins.friendly-snippets
      vimPlugins.rust-vim
      vimPlugins.cmp-cmdline
      vimPlugins.lspkind-nvim
      vimPlugins.lsp_extensions-nvim
      vimPlugins.cmp-nvim-lsp-document-symbol
      vimPlugins.cmp-tabnine
      vimPlugins.vim-clang-format
      vimPlugins.undotree
      vimPlugins.nvim-web-devicons
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-treesitter-textobjects
      vimPlugins.playground
      vimPlugins.markdown-preview-nvim
      vimPlugins.zen-mode-nvim
      vimPlugins.comment-nvim
      vimPlugins.vim-sleuth
      vimPlugins.lspsaga-nvim
      vimPlugins.nvim-notify
      vimPlugins.nvim-lint
      vimPlugins.vim-go
      vimPlugins.oil-nvim
    ];

    extraPackages = with pkgs; [
      # languages
      jsonnet
      nodejs
      # python311Full
      # rustc
      marksman

      # language servers
      gopls
      haskell-language-server
      jsonnet-language-server
      lua-language-server
      nil
      nodePackages."bash-language-server"
      nodePackages."diagnostic-languageserver"
      nodePackages."dockerfile-language-server-nodejs"
      nodePackages."pyright"
      nodePackages."typescript"
      nodePackages."typescript-language-server"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      rust-analyzer
      terraform-ls

      # formatters
      gofumpt
      golines
      nixpkgs-fmt
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
