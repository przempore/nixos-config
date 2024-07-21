{
  pkgs,
  pkgs-unstable,
  allowed-unfree-packages,
  permittedInsecurePackages,
  ...
}:
let
  lib = pkgs.lib;
in
{
  imports = [
    ./apps
    ./catppuccin.nix
  ] ++ (if builtins.pathExists ./private/default.nix then [ ./private ] else [ ]);

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  nixpkgs.config.permittedInsecurePackages = permittedInsecurePackages; # here for home-manager


  # Packages that should be installed to the user profile.
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "wezterm";
      TERM = "xterm-256color";
    };

    packages = with pkgs-unstable; [
      # fonts
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

      cachix
      onlyoffice-bin_latest
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

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor
      nh

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
      ksuperkey
      freetype
      clipster
      redshift
      keepassxc
      backblaze-b2
      blueman
      spotify

      blueberry
      geany

      # all from here goes to home-manager
      zathura
      nitrogen
      unzip

      obsidian
    ];
  };

  programs = {
    bat = {
      enable = true;
    };
    command-not-found.enable = false;
    nix-index =
      {
        enable = true;
        enableFishIntegration = true;
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
