# VM Home Manager Configuration
# Similar to dathomir but optimized for VM with bspwm
{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop # This includes bspwm, gtk, and screen settings
  ];

  # VM-specific home configuration
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";
  };

  # VM-optimized picom settings (less effects for better performance)
  services.picom.settings = {
    enable = false;
    backend = "xrender";
    fade = false;
    # shadow = false;
    blur = false;
    vsync = false;
  };

  # Simplified shell prompt for VM
  # programs.starship.settings = {
  #   format = "[VM] $all";
  #   right_format = "";
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
