{ pkgs, ... }:
{
  # dconf = {
  #   settings = {
  #     "org/gnome/desktop/interface" = {
  #       gtk-theme = "rose-pine";
  #       color-scheme = "prefer-dark";
  #     };
  #   };
  # };

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine-icons";
      package = pkgs.rose-pine-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  #   configPackages = with pkgs; [ xdg-desktop-portal-gtk ];
  # };
  qt = {
    enable = true;
    # platformTheme.name = "gtk2";
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
