{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "exa --tree --level=1 --long --icons --git -lh";
      lh = "ll -lah";
    };
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      [ -f /home/porebski/.dotfiles/private/fish/config.fish ]; and source /home/porebski/.dotfiles/private/fish/config.fish
      '';
  };
}
