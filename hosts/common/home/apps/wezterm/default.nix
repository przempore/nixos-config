{ pkgs, stdenv, fetchFromGitHub, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  xdg.configFile."wezterm/wezterm-session-manager/session-manager.lua".source = (pkgs.fetchFromGitHub {
      owner = "danielcopper";
      repo = "wezterm-session-manager";
      rev = "main";
      hash = "sha256-NmPKvAjNcYACsYvGievzICgm4lUCZsXQhXbuZcq339k=";
    } + /session-manager.lua);
}
