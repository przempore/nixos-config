{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop
  ];

  # VM-specific home configuration
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";
  };

  services.picom = {
    enable = false;
    settings = {
      backend = "xrender";
      fade = false;
      # shadow = false;
      blur = false;
      vsync = false;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
