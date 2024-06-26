{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza --tree --level=1 --long --icons --git -lh";
      lah = "ll -lah";
      tree = "eza --tree";
      asdf = "setxkbmap real-prog-dvorak";
      asdfc = "setxkbmap -option ctrl:nocaps && setxkbmap -option altwin:swap_lalt_lwin";
      aoeu = "setxkbmap pl";
    };
    interactiveShellInit = ''
      if type -q any-nix-shell
        any-nix-shell fish --info-right | source
      end

      # enable vi mode
      # fish_vi_key_bindings
    '';
  };
}
