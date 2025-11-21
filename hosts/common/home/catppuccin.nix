{ lib, catppuccin, home-manager-unstable, ... }:
let
  catppuccinModules =
    import (catppuccin + "/modules/home-manager/all-modules.nix");
  catppuccinModulesFiltered =
    builtins.filter (module: builtins.baseNameOf module != "vicinae.nix")
      catppuccinModules;
  catppuccinModule =
    lib.modules.importApply
      (catppuccin + "/modules/global.nix")
      { catppuccinModules = catppuccinModulesFiltered; };
in
{
  imports = [
    "${home-manager-unstable}/modules/programs/vivid.nix"
    catppuccinModule
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
