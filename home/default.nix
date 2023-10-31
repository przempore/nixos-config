{ config, pkgs, ... }:

let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
in
{
  imports = [
    ./nvim
    ./tmux.nix
    ./fish.nix
    ./bspwm
    ./sxhkd.nix
    ./kitty
    ./firefox.nix
    # ./eww
    ./polybar
  ];

  services.picom.enable = true;
  services.picom.settings = {
    shadow = true;
    shadow-radius = 7;
    shadow-offset-x = -7;
    shadow-offset-y = -7;
    shadow-exclude = [
        "name = 'Notification'"
        "class_g ?= 'Notify-osd'"
        "name = 'Plank'"
        "name = 'Docky'"
        "name = 'Kupfer'"
        "name = 'xfce4-notifyd'"
        "name *= 'VLC'"
        "name *= 'compton'"
        "name *= 'Chromium'"
        "name *= 'Chrome'"
        "class_g = 'Firefox' && argb"
        "class_g = 'Conky'"
        "class_g = 'Kupfer'"
        "class_g = 'Synapse'"
        "class_g ?= 'Notify-osd'"
        "class_g ?= 'Cairo-dock'"
        "class_g = 'Cairo-clock'"
        "class_g ?= 'Xfce4-notifyd'"
        "class_g ?= 'Xfce4-power-manager'"
        "_GTK_FRAME_EXTENTS@:c"
    ];
    fading = true;
    fade-in-step = 0.04;
    fade-out-step = 0.04;
    inactive-opacity = 1;
    frame-opacity = 0.95;
    inactive-opacity-override = true;
    focus-exclude = [ "class_g = 'Cairo-clock'" ];
    opacity-rule = [ "80:class_g = 'Alacritty'" ];
    blur-kern = "3x3box";
    # blur-background-exclude = [
    #   "window_type = 'dock'";
    #   "window_type = 'desktop'";
    #   "_GTK_FRAME_EXTENTS@:c"
    # ];
    backend = "xrender";
    vsync = false;
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
    refresh-rate = 0;
    detect-transient = true;
    detect-client-leader = true;
    use-damage = true;
    log-level = "warn";
    # wintypes:
    # {
    #   tooltip = { fade = true; shadow = true; opacity = 0.9; focus = true; full-shadow = false; };
    #   dock = { shadow = false; }
    #   dnd = { shadow = false; }
    #   popup_menu = { opacity = 0.9; }
    #   dropdown_menu = { opacity = 0.9; }
    # };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Przemek";
    userEmail = "przempore@gmail.com";
  };
  home.file.".config/ranger/rc.conf".text = ''
    set preview_images true
    set preview_images_method kitty
    set show_hidden true
  '';

  # Packages that should be installed to the user profile.
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";


    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "fish";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

      cachix
      neocmakelsp

      neofetch
      nnn # terminal file manager
      eza
      ripgrep
      any-nix-shell

      # archives
      zip
      xz
      p7zip

      # utils
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils  # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc  # it is a calculator for the IPv4/v6 addresses

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg
      whatsapp-for-linux
      signal-desktop-beta
      caprine-bin

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      hugo # static site generator
      glow # markdown previewer in terminal

      btop  # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      pulseaudioFull

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ];
  };

  programs = {
    bat = {
      enable = true;
      config = { theme = "catppuccin"; };
      themes = {
        catppuccin = builtins.readFile
          (catppuccin-bat + "/Catppuccin-mocha.tmTheme");
      };
    };
    starship = {
      enable = true;
      # custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };
  };


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
