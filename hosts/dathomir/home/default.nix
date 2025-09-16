{ lib, ... }:
{
  imports = [
    ../../common/home
    ../../common/home/desktop
    ./kitty.nix
  ];

  # Packages that should be installed to the user profile.
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";
    sessionVariables = {
      TERMINAL = "kitty";
    };
    pointerCursor = {
      size = 12;
    };
  };

  services.picom.settings = {
    fade = false;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
