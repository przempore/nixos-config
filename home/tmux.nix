{
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    # Stop tmux+escape craziness.
    escapeTime = 0;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      # vi is good
      unbind-key -T copy-mode-vi v
      setw -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection     # Begin selection in copy mode.
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle  # Begin selection in copy mode.
      bind-key -T copy-mode-vi 'y' send -X copy-selection      # Yank selection in copy mode.

      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
