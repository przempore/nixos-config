{ config, pkgs, ... }: {

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # here for nixos-rebuild

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the XFCE Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.bspwm.enable = true;

  services.xserver.extraLayouts.real-prog-dvorak = {
    description = "Real proogrammer dvorak";
    languages = [ "pl" ];
    symbolsFile = ./keyboard/symbols/real-prog-dvorak.xkb;
  };

  # Configure keymap in X11
  services.xserver = {
    autoRepeatDelay = 250;
    autoRepeatInterval = 30;
    layout = "real-prog-dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "nix-2.16.2" "electron-25.9.0" ];

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

}
