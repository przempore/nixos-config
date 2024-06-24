{ config, pkgs, ... }:
{
  imports = [
    ./bspwm
    ./picom.nix
    ./polybar
    ./screen_settings
    ./sxhkd.nix
  ];

  gtk = {
    enable = true;
    iconTheme.package = pkgs.arc-icon-theme;
    iconTheme.name = "Arc";
    theme = {
      name = "catppuccin-macchiato-pink-compact+rimless";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        # tweaks = [ "rimless" "black" ];
        tweaks = [ "rimless" ];
        variant = "macchiato";
      };
    };
  };

  # Now symlink the `~/.config/gtk-4.0/` folder declaratively:
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };
}
