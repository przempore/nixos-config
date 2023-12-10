{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza --tree --level=1 --long --icons --git -lh";
      lh = "ll -lah";
      tree = "eza --tree";
      asdf = "setxkbmap real-prog-dvorak";
      asdfc = "setxkbmap -option ctrl:nocaps && setxkbmap -option altwin:swap_lalt_lwin";
      aoeu = "setxkbmap pl";
    };
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      [ -f /home/porebski/.dotfiles/private/fish/config.fish ]; and source /home/porebski/.dotfiles/private/fish/config.fish
    '';
  };
}
