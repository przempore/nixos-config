# VM Development Environment Configuration
# Similar to dathomir but optimized for VM usage with bspwm
{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  # VM-specific system configuration
  networking.hostName = "dev-vm"; # rename it to "grievous"

  # Enable VM-specific services (conditional based on available services)
  services.qemuGuest.enable = lib.mkDefault true;
  services.spice-vdagentd.enable = lib.mkDefault true;

  services.displayManager = {
    # autoLogin.enable = true;
    # autoLogin.user = "przemek";
    defaultSession = "none+bspwm";
  };

  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;

  # VM optimizations (these will be provided by hardware-configuration.nix)

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  services.openvpn.servers = {
    officeVPN = {
      config = '' config /root/nixos/openvpn/officeVPN.conf '';
      updateResolvConf = true;
      autoStart = false;
      authUserPass.username = builtins.getEnv "OFFICE_VPN_USERNAME";
      authUserPass.password = builtins.getEnv "OFFICE_VPN_PASSWORD";
    };
  };

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };

  services.xserver.desktopManager.wallpaper.mode = "fill";

  time.timeZone = "Europe/Berlin";

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

  nix.settings.trusted-users = [ "root" "przemek" ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    htop
    tree
  ];

  users.users.przemek = {
    isNormalUser = true;
    description = "przemek";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  services.getty.autologinUser = "przemek";

  networking.firewall.enable = false; # Disabled for development ease
  networking.useDHCP = lib.mkDefault true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.05";
}
