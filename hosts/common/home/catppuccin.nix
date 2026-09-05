{ lib, pkgs, inputs, ... }:
let
  excludedModules = [ "neovim.nix" "vicinae.nix" "opencode.nix" "wezterm.nix" ];
  catppuccinModules =
    import (inputs.catppuccin + "/modules/home-manager/all-modules.nix");
  catppuccinModulesFiltered =
    builtins.filter (module: !(builtins.elem (builtins.baseNameOf module) excludedModules))
      catppuccinModules;
  catppuccinModule =
    lib.modules.importApply
      (inputs.catppuccin + "/modules/global.nix")
      { catppuccinModules = catppuccinModulesFiltered; };
in
{
  imports = [
    # "${inputs.home-manager-unstable}/modules/programs/vivid.nix"
    catppuccinModule
  ];

  # options.programs.delta = {
  #   enable = lib.mkOption {
  #     type = lib.types.bool;
  #     default = false;
  #   };
  #   options = lib.mkOption {
  #     type = lib.types.attrs;
  #     default = {};
  #   };
  # };

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
