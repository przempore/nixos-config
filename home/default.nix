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
    ./bspwm
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./kitty
    ./mpv.nix
    ./nvim
    ./picom.nix
    ./polybar
    ./ranger.nix
    ./screen_settings
    ./sxhkd.nix
    ./teleport.nix
    ./tmux.nix
    ./wezterm
    ./zathura.nix
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Packages that should be installed to the user profile.
  home = {
    username = "porebski";
    homeDirectory = "/home/porebski";


    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "fish";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      # here is some command line tools I use frequently
      # feel free to add your own or remove some of them

      cachix
      onlyoffice-bin_7_5
      netflix
      dash

      # archives
      zip
      xz
      p7zip

      # utils
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      brave
      signal-desktop
      caprine-bin

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      hugo # static site generator
      glow # markdown previewer in terminal

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb

      # all from here goes to home-manager
      # Desktop Environment
      # eww
      ksuperkey
      freetype
      clipster
      redshift
      keepassxc
      backblaze-b2
      blueman

      # this can be installed by flakes
      # gcc
      # clang-tools
      # clang
      # cmake
      # ninja
      # ccache
      # sccache
      # cargo
      # rustup
      # rustfmt
      # rust-analyzer
      # go
      # gopls
      # black
      # mypy
      # nodejs
      # nodePackages_latest.pyright
      blueberry
      geany

      # all from here goes to home-manager
      zathura
      nitrogen
      unzip
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
