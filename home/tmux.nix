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
      tmuxPlugins.catppuccin
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
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

      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'


      resurrect_dir="$HOME/.tmux/resurrect"
      set -g @resurrect-dir $resurrect_dir
      set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | sponge $target'


      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      set -g @catppuccin_flavour 'mocha' # or frappe, macchiato, mocha
      set -g @catppuccin_window_left_separator "█"
      set -g @catppuccin_window_right_separator "█ "
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_middle_separator "  █"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#{pane_current_path}"
      set -g @catppuccin_status_modules "application session date_time"
      set -g @catppuccin_status_left_separator  ""
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "yes"
      set -g @catppuccin_status_fill "all"
      set -g @catppuccin_status_connect_separator "no"
    '';
  };
}
