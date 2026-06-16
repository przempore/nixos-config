{ lib, pkgs, pkgs-unstable, nvim-config, ... }:
let
  pluginsList = nvim-config.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pluginsList;
  hasCatppuccin = builtins.any
    (plugin: builtins.match ".*catppuccin-nvim.*" (toString plugin) != null)
    pluginsList;
  plugins = pluginsList ++ lib.optionals (!hasCatppuccin) [ pkgs.vimPlugins.catppuccin-nvim ];
  explicitPluginType = plugin:
    if builtins.isAttrs plugin && plugin ? plugin && builtins.match ".*catppuccin-nvim.*" (toString plugin.plugin) != null then
      plugin // { type = "viml"; }
    else if builtins.isAttrs plugin && plugin ? plugin && !(plugin ? type) then
      plugin // { type = "viml"; }
    else
      plugin;
in
{
  # English words dictionary for completion
  home.file.".config/nvim/dictionary/words.txt".source = "${builtins.fetchGit {
    url = "https://github.com/dwyl/english-words";
    ref = "master";
    rev = "20f5cc9b3f0ccc8ce45d814c532b7c2031bba31c";
  }}/words.txt";

  home.file.".config/nvim" = {
    source = nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.config;
    recursive = true;
  };

  programs.neovim = {
    # Use neovim-nightly from nvim-config flake (unwrapped)
    # Home-manager will wrap it with the plugins below
    package = nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.neovim-unwrapped;

    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withRuby = true;

    plugins = map explicitPluginType plugins;

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
      diagnostic-languageserver
      pyright
      vscode-langservers-extracted
      yaml-language-server
      terraform-ls
    ];
  };
}
