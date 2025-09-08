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

  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "/run/current-system/sw/bin/bspwm";
  };
  
  # services.dbus.enable = true;
  # security.polkit.enable = true;

  # services.xrdp = {
  #   enable        = true;
  #   openFirewall  = true;        # port 3389 if you also RDP in over the LAN
  #   defaultWindowManager = "bspwm";
  #   extraConfDirCommands = ''
  #     # Start with the stock config
  #     install -D ${pkgs.xrdp}/etc/xrdp/xrdp.ini $out/xrdp.ini
  #
  #     # (a) turn vsock on
  #     sed -i $out/xrdp.ini -e 's/^use_vsock=.*/use_vsock=true/'
  #
  #     # (b) write the log in /run/xrdp (unit's WorkingDirectory)
  #     # sed -i $out/xrdp.ini -e 's|^LogFile=.*|LogFile=/run/xrdp/xrdp.log|'
  #   '';
  # };

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

  systemd.user.services.rustdesk = {
    description = "RustDesk remote desktop";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.rustdesk}/bin/rustdesk";
      Restart = "on-failure";
    };
  };

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
    extraUpFlags = [ "--accept-dns=true" ];
  };

  services.xserver.desktopManager.wallpaper.mode = "fill";

  virtualisation.docker.enable = true;

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
    xorg.xsetroot
    xorg.setxkbmap
    xclip
    xsel
  ];

  users.users.przemek = {
    isNormalUser = true;
    description = "przemek";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
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
