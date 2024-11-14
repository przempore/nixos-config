{ lib, config, ... }: {

  options.catppuccin = {
    modules.catppuccin.enable = lib.mkEnableOption "Enable Catpuccin theme";
  };

  config = lib.mkIf config.modules.catppuccin.enable {
    imports = [
      (import <home-manager> { }).homeManagerModules.catppuccin
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
  };
}
