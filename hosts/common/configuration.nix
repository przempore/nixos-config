{ pkgs, lib, config, ... }: {

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # here for nixos-rebuild

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  services.geoclue2.enable = true;
  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
  };

  # Enable the XFCE Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.extraConfig = ''
      user-background = false
      [greeter]
      show-manual-login = true
      allow-guest = false
    '';
  };
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.bspwm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    dpi = lib.mkDefault 90;
    autoRepeatDelay = 250;
    autoRepeatInterval = 30;
    xkb = {
      layout = "real-prog-dvorak";
      extraLayouts.real-prog-dvorak = {
        description = "Real proogrammer dvorak";
        languages = [ "pl" ];
        symbolsFile = ./keyboard/symbols/real-prog-dvorak.xkb;
      };
    };
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
    settings = {
      General = {
        Name = "Hello";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.allowed-unfree-packages;
  nixpkgs.config.permittedInsecurePackages = config.permittedInsecurePackages;

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
    rsync
    strace # system call monitoring
    tree
    vim
    wget
    which
    xorg.xbacklight
    xorg.xmodmap
    zstd
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

}
