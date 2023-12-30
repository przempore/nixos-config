# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "porebski" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-7e5a1347-6f7b-4c7b-acdb-125fa70f58c2".device = "/dev/disk/by-uuid/7e5a1347-6f7b-4c7b-acdb-125fa70f58c2";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "i915.force_probe=4626" ];

  boot.initrd.kernelModules = [ "i915" ];

  # environment.variables = {
  #  VDPAU_DRIVER = pkgs.lib.mkIf config.hardware.opengl.enable (pkgs.lib.mkDefault "va_gl");
  # };
  # hardware.opengl.extraPackages = with pkgs; [
  #   (if (pkgs.lib.versionOlder (pkgs.lib.versions.majorMinor pkgs.lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
  #   libvdpau-va-gl
  #   intel-media-driver
  # ];

  # services.tlp = {
  #   # enable = true;
  #   enable = pkgs.lib.mkDefault ((pkgs.lib.versionOlder (pkgs.lib.versions.majorMinor pkgs.lib.version) "21.05")
  #                                    || !config.services.power-profiles-daemon.enable);
  #   settings = {
  #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

  #     CPU_MIN_PERF_ON_AC = 0;
  #     CPU_MAX_PERF_ON_AC = 100;
  #     CPU_MIN_PERF_ON_BAT = 0;
  #     CPU_MAX_PERF_ON_BAT = 20;

  #    #Optional helps save long term battery health
  #    START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
  #    STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

  #   };
  # };

  networking.hostName = "dooku"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.bspwm.enable = true;
  # services.xserver = {
    # enable = true;   
    # displayManager.gdm.enable = true;
    # displayManager.defaultSession = "none+bspwm";
    # displayManager = {
    #   lightdm = {
    #     enable = true;
    #     greeters.slick.enable = true;
    #   };
    #   defaultSession = "none+bspwm";
    # };
    # desktopManager = {
    #   xterm.enable = false;
    #   xfce = {
    #     enable = true;
    #     noDesktop = true;
    #     enableXfwm = false;
    #   };
    # };
    # windowManager.bspwm.enable = true;
  # };

  services.xserver.extraLayouts.real-prog-dvorak = {
    description = "Real proogrammer dvorak";
    languages = [ "pl" ];
    symbolsFile = ./keyboard/symbols/real-prog-dvorak.xkb;
  };

  # Configure keymap in X11
  services.xserver = {
    autoRepeatDelay = 200;
    autoRepeatInterval = 25;
    layout = "real-prog-dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  services.qemuGuest.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.pulseaudio.extraConfig = "
    load-module module-switch-on-connect
  ";
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = true;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.porebski = {
    isNormalUser = true;
    description = "Porebski";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    liberation_ttf
    source-code-pro
    siji
    nerdfonts
    powerline-fonts
    powerline-symbols
    font-awesome
    line-awesome
    material-icons
    material-symbols
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # system call monitoring
    arandr
    autorandr
    bat
    btop # replacement of htop/nmon
    cowsay
    eza
    file
    fish
    fzf
    gawk
    git
    gnupg
    gnused
    gnutar
    htop
    iftop # network monitoring
    iotop # io monitoring
    killall
    lsof # list open files
    ltrace # library call monitoring
    ripgrep
    rsync
    strace # system call monitoring
    tree
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    which
    xorg.xbacklight
    xorg.xmodmap
    zstd
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
