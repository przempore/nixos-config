# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      ../common/configuration.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia-drivers.nix
    ];

  nix.settings.trusted-users = [ "root" "przemek" ];

  # boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "ilum"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.qemuGuest.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="input", GROUP="input", MODE="0660"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
  '';

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onShutdown = "shutdown";
  programs.virt-manager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.przemek = {
    isNormalUser = true;
    description = "Przemek";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "dialout" ];
    packages = with pkgs; [
      ltunify
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
