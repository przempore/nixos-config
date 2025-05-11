{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # withUWSM  = true;
  };

  environment.systemPackages = with pkgs; [
    # home.packages = with pkgs; [
    hyprland
    hyprlock
    hyprpaper # Wallpaper utility
    hyprshot
    waybar # Status bar
    wofi # Application launcher
    dunst # Notification daemon
    cliphist
    wl-clipboard
    wlsunset
    xdg-desktop-portal-hyprland # For screen sharing, file dialogs
    qt5.qtwayland # Qt Wayland support
    qt6.qtwayland
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

}
