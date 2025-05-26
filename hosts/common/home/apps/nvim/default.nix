{ pkgs, pkgs-unstable, neovim, ... }:
let
  cscope_maps-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "cscope_maps-nvim";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "dhananjaylatkar";
      repo = "cscope_maps.nvim";
      rev = "66d044b1949aa4912261bbc61da845369d54f971";
      sha256 = "sha256-pC5iWtuHz2Gr9EgEJXaux9VEM4IJhVmQ4bkGC0GEvuA=";
    };
    dependencies = [ pkgs.vimPlugins.telescope-nvim pkgs.vimPlugins.fzf-lua ];
    nvimSkipModules = [ "cscope.pickers.telescope" "cscope.pickers.fzf-lua" ];
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
    dependencies = [ pkgs.vimPlugins.plenary-nvim pkgs.vimPlugins.telescope-nvim ];
    nvimRequireCheck = [ "git-worktree.status" "git-worktree.enum" ];
    nvimSkipModules = [ "git-worktree.test" "git-worktree" ];
  };
  harpoon2_rev_lock = pkgs.vimUtils.buildVimPlugin {
    name = "harpoon2_rev_lock";
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "e76cb03c420bb74a5900a5b3e1dde776156af45f";
      sha256 = "sha256-oL/D/uiXr0dvK4D6VDlgyGb8gA01i/xrwOYr54Syib8=";
    };
  };
  direnv-vim = pkgs.vimUtils.buildVimPlugin {
    # lsp is going crazy in git-worktree with this plugin
    name = "direnv-vim";
    src = pkgs.fetchFromGitHub {
      owner = "direnv";
      repo = "direnv.vim";
      rev = "master";
      sha256 = "sha256-Lwwm95UEkS8Q0Qsoh10o3sFn48wf7v7eCX/FJJV1HMI=";
    };
  };
  neovim-nightly = neovim.packages.${pkgs.system}.default.overrideAttrs (old: {
    meta = old.meta or { } // {
      maintainers = [ ];
    };
  });
in
{
  home.file.".config/nvim" = {
    source = ./config;
    recursive = true;
  };

  home.file.".config/nvim/dictionary/words.txt".source = "${builtins.fetchGit {
    url = "https://github.com/dwyl/english-words";
    ref = "master";
    rev = "20f5cc9b3f0ccc8ce45d814c532b7c2031bba31c";
  }}/words.txt";

  home.packages = [
    # pkgs.vscode-extensions.ms-vscode.cpptools
  ];

  programs.neovim = {
    # package = pkgs-unstable.neovim-unwrapped;
    package = neovim-nightly;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs-unstable; [
      # Main plugins
      # direnv-vim
      # harpoon2_rev_lock
      # vimPlugins.git-worktree-nvim
      cscope_maps-nvim
      telescope-git-worktrees
      vimPlugins.CopilotChat-nvim
      vimPlugins.avante-nvim
      vimPlugins.blink-cmp
      vimPlugins.blink-cmp-avante
      vimPlugins.blink-cmp-dictionary
      vimPlugins.blink-copilot
      vimPlugins.colorful-menu-nvim
      vimPlugins.comment-nvim
      vimPlugins.copilot-lua
      vimPlugins.debugprint-nvim
      vimPlugins.dressing-nvim
      vimPlugins.fidget-nvim
      vimPlugins.firenvim
      vimPlugins.friendly-snippets
      vimPlugins.friendly-snippets
      vimPlugins.fzf-checkout-vim
      vimPlugins.fzf-vim
      vimPlugins.gitsigns-nvim
      vimPlugins.harpoon2
      vimPlugins.img-clip-nvim
      vimPlugins.lsp-zero-nvim
      vimPlugins.lsp_extensions-nvim
      vimPlugins.lspkind-nvim
      vimPlugins.lspkind-nvim
      vimPlugins.lspsaga-nvim
      vimPlugins.luasnip
      vimPlugins.luasnip
      vimPlugins.markdown-preview-nvim
      vimPlugins.mason-lspconfig-nvim
      vimPlugins.mason-nvim
      vimPlugins.mason-tool-installer-nvim
      vimPlugins.neodev-nvim
      vimPlugins.nvim-dap
      vimPlugins.nvim-dap-ui
      vimPlugins.nvim-dap-virtual-text
      vimPlugins.nvim-fzf
      vimPlugins.nvim-lint
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-notify
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-treesitter-textobjects
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.nvim-web-devicons
      vimPlugins.nvim-web-devicons
      vimPlugins.obsidian-nvim
      vimPlugins.oil-nvim
      vimPlugins.palette-nvim
      vimPlugins.playground
      vimPlugins.plenary-nvim
      vimPlugins.pomo-nvim
      vimPlugins.project-nvim
      vimPlugins.rust-vim
      vimPlugins.snacks-nvim
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

    extraPackages = with pkgs-unstable; [
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
      pyright
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      terraform-ls
    ];
  };
}
