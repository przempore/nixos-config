{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wezterm
  ];

  programs.wezterm = {
    enable = true;
  };

  home.file.".wezterm.lua".source = ./wezterm.lua;
}
