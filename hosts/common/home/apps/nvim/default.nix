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

    plugins = [
      # direnv-vim
      # harpoon2_rev_lock
      # vimPlugins.git-worktree-nvim
      cscope_maps-nvim
      telescope-git-worktrees
      wf-nvim
    ] ++ (with pkgs-unstable.vimPlugins; [
      CopilotChat-nvim
      avante-nvim
      blink-cmp
      blink-cmp-avante
      blink-cmp-dictionary
      blink-copilot
      colorful-menu-nvim
      comment-nvim
      copilot-lua
      debugprint-nvim
      dressing-nvim
      fidget-nvim
      firenvim
      friendly-snippets
      friendly-snippets
      fzf-checkout-vim
      fzf-vim
      gitsigns-nvim
      harpoon2
      img-clip-nvim
      lsp-zero-nvim
      lsp_extensions-nvim
      lspkind-nvim
      lspsaga-nvim
      luasnip
      luasnip
      markdown-preview-nvim
      mason-lspconfig-nvim
      mason-nvim
      mason-tool-installer-nvim
      neodev-nvim
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-fzf
      nvim-lint
      nvim-lspconfig
      nvim-notify
      nvim-numbertoggle
      nvim-treesitter-context
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      nvim-web-devicons
      obsidian-nvim
      oil-nvim
      palette-nvim
      playground
      plenary-nvim
      pomo-nvim
      project-nvim
      rust-vim
      snacks-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      undotree
      vim-be-good
      vim-clang-format
      vim-fugitive
      vim-go
      vim-qml
      vim-rhubarb
      vim-sleuth
      zen-mode-nvim
    ]);

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
      # nil - moved to flake devShell (only needed for NixOS config development)
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
