{ pkgs, lib, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.displayManager.defaultSession = lib.mkDefault "hyprland-uwsm";

  # Stopping either unit during a rebuild tears down the active desktop session.
  systemd.user.services = lib.genAttrs [
    "wayland-wm@"
    "wayland-session-bindpid@"
  ]
    (_: {
      restartIfChanged = false;
      # Keep the PATH imported by UWSM instead of adding a minimal service PATH.
      enableDefaultPath = false;
    });

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xdg-desktop-portal-hyprland # For screen sharing, file dialogs
    qt5.qtwayland # Qt Wayland support
    qt6.qtwayland
  ];

  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

}
