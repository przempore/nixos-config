{ lib, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = lib.mkDefault {
      ll = "eza --tree --level=1 --long --icons --git -lh";
      lah = "ll -lah";
      tree = "eza --tree";
      asdf = "setxkbmap real-prog-dvorak";
      asdfc = "setxkbmap -option ctrl:nocaps && setxkbmap -option altwin:swap_lalt_lwin";
      aoeu = "setxkbmap pl";
    };
    interactiveShellInit = lib.mkDefault ''
      if type -q any-nix-shell
        any-nix-shell fish --info-right | source
      end

      fish_default_key_bindings
    '';
  };
}
