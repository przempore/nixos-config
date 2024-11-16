{ lib, ... }: {
  imports = [
    ../hosts/common/home/apps/direnv-module.nix
  ];

  modules = {
    direnv.enable = lib.mkDefault true;
  };
}
