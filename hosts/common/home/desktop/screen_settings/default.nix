{ pkgs, ... }:
{
  home.packages = with pkgs; [
    feh
  ];

  home.file.".background-image" = {
    source = ./wallpaper/nature_of_fear_Nicola_Samori.jpg;
    # source = ./wallpaper;
  };
}
