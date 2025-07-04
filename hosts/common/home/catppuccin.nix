{ lib, catppuccin, ... }: {
  imports = [
    catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = lib.mkDefault true;
    flavor = "mocha";
    accent = "pink";
    cursors = {
      enable = true;
      accent = "dark";
    };
    gtk.enable = false;
  };
}
