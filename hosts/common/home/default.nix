{ pkgs
, pkgs-unstable
, lib
, allowed-unfree-packages
, permittedInsecurePackages
, ...
}: {
  imports = [
    ./apps
    ./catppuccin.nix
  ] ++ (lib.optional (builtins.pathExists ./private/default.nix) ./private);

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  nixpkgs.config.permittedInsecurePackages = permittedInsecurePackages; # here for home-manager


  # Packages that should be installed to the user profile.
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "ghostty";
      TERM = "xterm-256color";
      # NVD_BACKEND = "direct";
    };

    pointerCursor = {
      gtk.enable = true; # Enable cursor theming for GTK applications
      x11.enable = true; # Enable for X11 (e.g., when using XWayland)
      package = lib.mkDefault pkgs.catppuccin-cursors; # Use the Catppuccin cursors package
      name = "catppuccin-mocha-dark-cursors"; # Specific Mocha Dark variant
      size = lib.mkDefault 24; # Match the size you used with nwg-look
    };

    packages = with pkgs-unstable; [
      claude-code
      superfile
    ] ++ (with pkgs; [
      cachix
      # netflix
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


      # nix related
      #
      # Development tools moved to flake devShell
      # nix-output-monitor - moved to devShell
      # nh - moved to devShell

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
      backblaze-b2
      blueman

      blueberry
      # geany

      # all from here goes to home-manager
      nitrogen
      unzip
    ]);
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
    eza = {
      enable = true;
      git = true;
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
  home.stateVersion = lib.mkDefault "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
