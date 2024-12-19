{ lib, catppuccin, ... }: {
  imports = [
    catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin = {
    enable = lib.mkDefault true;
    flavor = "mocha";
    accent = "pink";
    pointerCursor = {
      enable = true;
      accent = "dark";
    };
  };
}
