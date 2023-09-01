{
  pkgs,
  config,
  ...
}: {
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
      # tabnine-nvim
      vimPlugins.copilot-vim
      vimPlugins.vim-fugitive
      vimPlugins.vim-rhubarb
      vimPlugins.nvim-fzf
      vimPlugins.plenary-nvim
      vimPlugins.telescope-nvim
      vimPlugins.telescope-fzf-native-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nvim-fzf
      vimPlugins.vim-qml
      vimPlugins.catppuccin-nvim
      vimPlugins.vim-be-good
      vimPlugins.cmp-git
      vimPlugins.git-worktree-nvim
      vimPlugins.harpoon
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
      vimPlugins.lualine-nvim
      vimPlugins.lspsaga-nvim
      vimPlugins.nvim-notify
      vimPlugins.nvim-lint
      vimPlugins.vim-go
    ];

    extraPackages = with pkgs; [
      # languages
      jsonnet
      nodejs
      python311Full
      rustc
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
      python310Packages.black
      rustfmt

      # tools
      cmake
      cmake-language-server
      gnumake
      checkmake
      cargo
      gcc
      llvmPackages.clang-unwrapped # c/c++ tools with clang-tools such as clangd
      gdb
      lldb
      ghc
      lazydocker
      yarn
    ];
  };
}
