{ ... }:
{
  imports = [ ../home/desktop/noctalia.nix ];

  home.file.".config/niri/config.kdl".text = import ./config.nix;
}
