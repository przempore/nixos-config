{ pkgs, ... }: {
  imports = [
    ../../common/home/apps/kitty
  ];

  programs.kitty = {
    settings = {
      font_size = 8;
    };
  };
}
