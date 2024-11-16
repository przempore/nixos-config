{ pkgs, ... }: {
  home.packages = with pkgs; [
    feh
  ];

  home.file.".background-image" = {
    source = ./wallpaper;
  };
}
