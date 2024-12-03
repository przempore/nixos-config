{ pkgs, ... }:
{
  gtk = {
    enable = true;
    # theme = {
    #   name = "rose-pine";
    #   package = pkgs.rose-pine-gtk-theme;
    # };
    # iconTheme = {
    #   name = "rose-pine";
    #   package = pkgs.rose-pine-icon-theme;
    # };


    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
      tweaks = [ "rimless" ];
      icon = {
        enable = true;
        accent = "pink";
        flavor = "macchiato";
      };
    };
  };
}
