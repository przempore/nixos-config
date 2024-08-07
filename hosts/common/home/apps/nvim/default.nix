{ pkgs, pkgs-unstable, ... }:
let
  cscope_maps-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "cscope_maps-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "dhananjaylatkar";
      repo = "cscope_maps.nvim";
      rev = "67fecf61bac73cd191bfb4918f19b515019f2d89";
      sha256 = "sha256-i7EiBS114jRIm1l9hAifW12Eydfu0bGLkV/dZJznCp8=";
    };
  };
  wf-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "wf-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "Cassin01";
      repo = "wf.nvim";
      rev = "716f2151bef7b38426a99802e89566ac9211978a";
      sha256 = "sha256-4RwTZP3Oz0Rj/PB9NV+FsdOsLMZZQMW+y25A7MWt9qo=";
    };
  };
  telescope-git-worktrees = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-git-worktrees";
    src = pkgs.fetchFromGitHub {
      owner = "awerebea";
      repo = "git-worktree.nvim";
      rev = "a3917d0b7ca32e7faeed410cd6b0c572bf6384ac";
      sha256 = "sha256-CC9+h1i+l9TbE60LABZnwjkHy94VGQ7Hqd5jVHEW+mw=";
    };
  };
in
{
  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };

  home.packages = [
    pkgs.vscode-extensions.ms-vscode.cpptools
  ];

  programs.neovim = {
    package = pkgs-unstable.neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs-unstable; [
      cscope_maps-nvim
      telescope-git-worktrees
      wf-nvim
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
      # vimPlugins.git-worktree-nvim
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
      vimPlugins.nvim-dap
      vimPlugins.nvim-dap-virtual-text
      vimPlugins.nvim-dap-ui
    ];

    extraPackages = with pkgs; [
      # tabnine
      neocmakelsp
      nixd
      cscope

      # languages
      jsonnet
      nodejs
      marksman

      # language servers
      lua-language-server
      nil
      nodePackages."bash-language-server"
      nodePackages."diagnostic-languageserver"
      nodePackages."dockerfile-language-server-nodejs"
      nodePackages."pyright"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      terraform-ls
    ];
  };
}
