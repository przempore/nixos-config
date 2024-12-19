{ lib, catppuccin, ... }: {
  imports = [
    catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin = {
    enable = lib.mkDefault true;
    flavor = "mocha";
    accent = "pink";
    cursors = {
      enable = true;
      accent = "dark";
    };
    gtk = {
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
