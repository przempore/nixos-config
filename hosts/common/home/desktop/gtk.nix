{ pkgs, lib, ... }:
let
  flavour = "mocha";
  accent = "pink";
  size = "compact";
  themeName = "catppuccin-${flavour}-${accent}-${size}";
in
{
  home.packages = with pkgs; [
    numix-gtk-theme
    (catppuccin-gtk.override {
      accents = [ accent ];
      variant = flavour;
      size = size;
    })
  ];
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = themeName;
      };
    };
  };

  home.sessionVariables = {
    GTK_THEME = "${themeName}:dark";
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
  };

  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = (pkgs.catppuccin-gtk.override {
        accents = [ accent ];
        variant = flavour;
        size = size;
      });
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
