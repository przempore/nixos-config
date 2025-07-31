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
      # Manual nix shell detection and display
      _nix_shell_info() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          if [[ "$IN_NIX_SHELL" == "impure" ]]; then
            echo "%F{yellow}[nix-shell]%f"
          elif [[ "$IN_NIX_SHELL" == "pure" ]]; then
            echo "%F{blue}[nix-shell:pure]%f"
          else
            echo "%F{green}[nix-shell]%f"
          fi
        elif [[ -n "$NIX_SHELL_PACKAGES" ]]; then
          echo "%F{cyan}[nix-develop]%f"
        fi
      }
      
      # Custom precmd to show nix shell info in right prompt
      _nix_shell_precmd() {
        local nix_info=$(_nix_shell_info)
        if [[ -n "$nix_info" ]]; then
          RPROMPT="$nix_info"
        else
          RPROMPT=""
        fi
      }
      
      # Add to precmd hooks
      autoload -Uz add-zsh-hook
      add-zsh-hook precmd _nix_shell_precmd
      
      # Wrapper functions for nix commands (similar to any-nix-shell)
      if command -v any-nix-shell >/dev/null 2>&1; then
        nix-shell() {
          any-nix-shell zsh "$@"
        }
        
        nix() {
          if [[ "$1" == "develop" || "$1" == "shell" ]]; then
            any-nix-shell zsh nix "$@"
          else
            command nix "$@"
          fi
        }
      fi
      
      # Set emacs mode key bindings (readline/default)
      bindkey -e
      
      # Custom history search with arrow keys
      bindkey "^[[A" history-search-backward
      bindkey "^[[B" history-search-forward
      
      # Fish-like autosuggestions behavior
      bindkey "^[[C" forward-char  # Right arrow accepts suggestion
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