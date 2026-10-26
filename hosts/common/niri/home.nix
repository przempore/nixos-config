{ ... }:
{
  imports = [ ../home/desktop/noctalia.nix ];

  home.file.".config/niri/config.kdl".source = ./config.kdl;
}
