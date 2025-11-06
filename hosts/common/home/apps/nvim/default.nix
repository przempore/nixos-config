{ pkgs, pkgs-unstable, neovim, nvim-config, ... }:
let
  # Custom plugins not in nixpkgs
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

  neovim-nightly = neovim.packages.${pkgs.system}.default.overrideAttrs (old: {
    meta = old.meta or { } // {
      maintainers = [ ];
    };
  });
in
{
  # Use the nvim-config from the separate repository
  # This uses the processed 'config' package output from the flake
  # which includes only: after/, init.lua, lua/ (excludes flake.nix, README, install scripts, etc.)
  home.file.".config/nvim" = {
    source = nvim-config.packages.${pkgs.system}.config;
    recursive = true;
  };

  # English words dictionary for completion
  home.file.".config/nvim/dictionary/words.txt".source = "${builtins.fetchGit {
    url = "https://github.com/dwyl/english-words";
    ref = "master";
    rev = "20f5cc9b3f0ccc8ce45d814c532b7c2031bba31c";
  }}/words.txt";

  programs.neovim = {
    package = neovim-nightly;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = [
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
      obsidian-nvim
      oil-nvim
      palette-nvim
      playground
      plenary-nvim
      pomo-nvim
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
      neocmakelsp
      nixd
      cscope

      # languages
      nodejs
      marksman

      # language servers
      lua-language-server
      dockerfile-language-server
      bash-language-server
      nodePackages."diagnostic-languageserver"
      pyright
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      terraform-ls
    ];
  };
}
