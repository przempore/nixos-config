{ lib, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza --tree --level=1 --long --icons --git -lh";
      lah = "ll -lah";
      tree = "eza --tree";
      asdf = lib.mkDefault "setxkbmap real-prog-dvorak";
      asdfc = lib.mkDefault "setxkbmap -option ctrl:nocaps && setxkbmap -option altwin:swap_lalt_lwin";
      aoeu = lib.mkDefault "setxkbmap pl";
    };
    interactiveShellInit = ''
      if type -q any-nix-shell
        any-nix-shell fish --info-right | source
      end

      fish_default_key_bindings
    '';
  };
}
