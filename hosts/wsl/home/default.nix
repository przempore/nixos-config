{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
  ];

  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";

    packages = with pkgs; [
      rclone

      netcat
      nmap

      jq
      yq-go
      tree
      htop
      btop
      neofetch

      file
      which

      zip
      unzip
      gzip

      git-lfs
      github-cli

      lsof
      psmisc
      procps

      wget
      curl

      nodejs

      docker-compose
    ] ++ (with pkgs-unstable; [
      claude-code
      superfile
    ]);

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERM = "xterm-256color";
      # WSL specific
      WSL_DISTRO_NAME = "NixOS";
    };
  };

  programs = {
    zsh.enable = true;
    fish.enable = false;
  };

  # This value determines the home Manager release
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself
  programs.home-manager.enable = true;
}
