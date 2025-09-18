{ lib, catppuccin, home-manager-unstable, ... }: {
  imports = [
    "${home-manager-unstable}/modules/programs/vivid.nix"
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
  };
}
