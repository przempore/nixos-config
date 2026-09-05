{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../common/base.nix
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "przemek";
    startMenuLaunchers = true;
  };

  # WSL-specific system configuration
  networking.hostName = "wsl";

  # Disable bootloader for WSL
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  services.xserver.desktopManager.xfce.enable = false;
  services.xserver.windowManager.bspwm.enable = false;

  # Enable essential services for CLI development
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Enable zsh system-wide (required when user shell is zsh)
  programs.zsh.enable = true;

  # CLI-focused system packages (from dev-vm)
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    htop
    tree
    # Additional CLI tools
    tmux
    fzf
    ripgrep
    fd
    bat
    delta
    zoxide
    direnv
    unzip
    rsync
  ];

  virtualisation.docker.enable = true;

  users.users.przemek = {
    isNormalUser = true;
    description = "przemek";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  services.openvpn.servers = {
    officeVPN = {
      config = ''
        config /etc/openvpn/officeVPN.conf
        auth-user-pass ${config.sops.secrets."openvpn/office-auth".path}
      '';
      autoStart = false;
    };
  };

  sops.secrets."openvpn/office-auth" = {
    sopsFile = ../../secrets/secrets.yaml;
    key = "openvpn_office_auth";
  };

  # WSL doesn't need firewall typically
  networking.firewall.enable = false;
  networking.useDHCP = lib.mkDefault true;

  system.stateVersion = "25.05";
}
