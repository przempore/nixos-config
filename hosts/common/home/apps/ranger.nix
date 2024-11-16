{ pkgs, ... }: {
  home.packages = with pkgs; [
    ranger
  ];

  home.file.".config/ranger/rc.conf".text = ''
    set preview_images true
    set preview_images_method kitty
    set show_hidden true
  '';
}
