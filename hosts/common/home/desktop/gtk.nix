{ pkgs, ... }:
{
  # dconf = {
  #   settings = {
  #     "org/gnome/desktop/interface" = {
  #       # gtk-theme = "rose-pine";
  #       # color-scheme = "prefer-dark";
  #       gtk-theme = "rose-pine";
  #       color-scheme = "prefer-dark";
  #     };
  #   };
  # };

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = true;
    # };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # qt = {
  #   enable = true;
  #   style.name = "kvantum";
  #   platformTheme.name = "kvantum";
  # };
  #
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  #   configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  # };
}
