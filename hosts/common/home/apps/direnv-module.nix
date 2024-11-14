{ lib, config, pkgs, ... }: {

  options = {
    modules.direnv.enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf config.modules.direnv.enable {
    programs.direnv = {
      enable = lib.mkDefault true;
      package = pkgs.direnv;
      silent = true;
      loadInNixShell = true;
      direnvrcExtra = "";
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };
  };
}
