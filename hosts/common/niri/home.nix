{ ... }:
{
  imports = [ ../home/desktop/noctalia.nix ];

  home.file.".config/niri/config.kdl".text = import ./config.nix;

  # libxkbcommon searches the user's XKB directory for custom layouts.
  xdg.configFile."xkb/symbols/real-prog-dvorak".source =
    ../keyboard/symbols/real-prog-dvorak.xkb;
}
