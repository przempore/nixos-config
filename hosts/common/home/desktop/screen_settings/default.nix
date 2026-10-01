{ pkgs, ... }:
{
  home.packages = with pkgs; [
    feh
  ];

  xdg.mimeApps.defaultApplications."image/jpeg" = [ "feh.desktop" ];

  home.file.".background-image" = {
    source = ./wallpaper/nature_of_fear_Nicola_Samori.jpg;
    # source = ./wallpaper;
  };
}
