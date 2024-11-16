{ pkgs, ... }: {
  home.packages = with pkgs; [
    zathura
  ];

  programs.zathura = {
    enable = true;
    # custom settings
    options = {
      selection-clipboard = "clipboard";
    };
  };
}
