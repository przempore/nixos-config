{ config, lib, ... }:
{
  programs.niri.enable = true;

  home-manager.sharedModules = lib.mkIf config.programs.niri.enable [
    ./home.nix
  ];
}
