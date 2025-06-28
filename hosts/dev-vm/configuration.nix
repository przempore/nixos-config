# VM Development Environment Configuration
# Similar to dathomir but optimized for VM usage with bspwm
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  # VM-specific system configuration
  networking.hostName = "dev-vm";

  # Enable VM-specific services (conditional based on available services)
  services.qemuGuest.enable = lib.mkDefault true;
  services.spice-vdagentd.enable = lib.mkDefault true;

  # VM optimizations (these will be provided by hardware-configuration.nix)

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  # Set timezone like dathomir
  time.timeZone = "Europe/Berlin";

  # Locale settings
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Trusted users for nix
  nix.settings.trusted-users = [ "root" "przemek" ];

  # VM-specific packages
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    htop
    tree
  ];

  # Define user account similar to dathomir
  users.users.przemek = {
    isNormalUser = true;
    description = "przemek";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Auto-login for easier VM access
  services.getty.autologinUser = "przemek";

  # Network configuration for VM
  networking.firewall.enable = false; # Disabled for development ease
  networking.useDHCP = lib.mkDefault true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.05";
}
