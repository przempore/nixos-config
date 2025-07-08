{ pkgs, ... }:
{
  home.packages = with pkgs; [
    numix-gtk-theme
  ];
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "rose-pine-dawn";
        icon-theme = "rose-pine-icons";
      };
    };
  };

  home.sessionVariables = {
    GTK_THEME = "rose-pine-dawn:dark";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  };

  gtk = {
    enable = true;
    theme = {
      name = "rose-pine-dawn";
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
