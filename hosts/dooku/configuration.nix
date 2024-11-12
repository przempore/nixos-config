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

      ../common/home/apps/kanata.nix
    ];

  nix.settings.trusted-users = [ "root" "porebski" ];

  boot.initrd.luks.devices."luks-7e5a1347-6f7b-4c7b-acdb-125fa70f58c2".device = "/dev/disk/by-uuid/7e5a1347-6f7b-4c7b-acdb-125fa70f58c2";
  # boot.kernelParams = [ "i915.force_probe=4626" ];

  # boot.initrd.kernelModules = [ "i915" ];

  networking.hostName = "dooku"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

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

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onShutdown = "shutdown";
  programs.virt-manager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.porebski = {
    isNormalUser = true;
    description = "Porebski";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "dialout" ];
    packages = with pkgs; [
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
