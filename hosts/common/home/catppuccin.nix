{ lib, catppuccin, home-manager-unstable, ... }: {
  imports = [
    "${home-manager-unstable}/modules/programs/vivid.nix"
    catppuccin.homeModules.catppuccin
  ];

  options.programs.delta = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    options = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = {
    catppuccin = {
      enable = lib.mkDefault true;
      flavor = "mocha";
      accent = "pink";
      cursors = {
        enable = true;
        accent = "dark";
      };
    };
  };
}
