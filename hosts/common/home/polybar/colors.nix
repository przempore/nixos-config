{ config, pkgs, ... }:
let
  catppuccin-polybar = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "polybar";
    rev = "9ee66f83335404186ce979bac32fcf3cd047396a";
    sha256 = "sha256-bUbSgMg/sa2faeEUZo80GNmhOX3wn2jLzfA9neF8ERA=";
  };
in
{
  services.polybar.config = {
    # "colors" = builtins.readFile (catppuccin-polybar + "/themes/mocha.ini");
    "colors" = {
      background = "#0a0f14";
      foreground = "#99d1ce";
      alert = "#d26937";
      volume-min = "#2aa889";
      volume-med = "#edb443";
      volume-max = "#c23127";
    };
  };
}
