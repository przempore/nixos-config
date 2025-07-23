{ lib, pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [
    any-nix-shell
  ];

  programs.zsh = {
    enable = lib.mkDefault false;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "eza --tree --level=1 --long --icons --git -lh";
      lah = "ll -lah";
      tree = "eza --tree";
      asdf = lib.mkDefault "setxkbmap real-prog-dvorak";
      asdfc = lib.mkDefault "setxkbmap -option ctrl:nocaps && setxkbmap -option altwin:swap_lalt_lwin";
      aoeu = lib.mkDefault "setxkbmap pl";
      sb = lib.mkDefault "cd ~/Projects/second-brain/; vi .";
    };
    
    initContent = ''
      # Set emacs mode key bindings
      bindkey -e
      
      # Enable better history search
      bindkey "^R" history-incremental-search-backward
      bindkey "^[[A" history-search-backward
      bindkey "^[[B" history-search-forward
      
      # Fish-like autosuggestions behavior
      bindkey "^[[C" forward-char  # Right arrow accepts suggestion
      bindkey "^I" complete-word   # Tab completion
    '';
    
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
    };
  };
}
