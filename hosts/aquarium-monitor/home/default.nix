{ lib, ... }:
{
  imports = [
    ../../common/home
    # ../../common/home/desktop
    # ./kitty.nix
  ];

  # Packages that should be installed to the user profile.
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";
    stateVersion = "26.05";
  };
  #
  # services.picom.settings = {
  #   fade = false;
  # };

  # Let home Manager install and manage itself.
  # programs.home-manager.enable = true;
}
