{ pkgs, ... }:
{
  imports = [
    ../../common/home/kitty
  ];

  programs.kitty = {
    settings = {
      font_size = 8;
    };
  };
}
