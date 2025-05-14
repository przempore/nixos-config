{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # withUWSM  = true;
  };

  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hyprpaper # Wallpaper utility
    hyprshot
    wofi # Application launcher
    cliphist
    wl-clipboard
    xdg-desktop-portal-hyprland # For screen sharing, file dialogs
    qt5.qtwayland # Qt Wayland support
    qt6.qtwayland
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

}
