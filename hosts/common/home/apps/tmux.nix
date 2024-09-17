{ pkgs
, pkgs-unstable
, ...
}: {
  programs.tmux = {
    enable = true;
    package = pkgs-unstable.tmux;
    shortcut = "a";
    # Stop tmux+escape craziness.
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator "  █"

          set -g @catppuccin_window_default_fill "number"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#{pane_current_path}"

          set -g @catppuccin_status_modules_right "application session date_time"
          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "yes"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          # source: https://github.com/p3t33/nixos_flake/blob/master/home/modules/tmux.nix
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'

          set -g @resurrect-capture-pane-contents 'on'

          resurrect_dir="$HOME/.tmux/resurrect"
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g" $target | sponge $target'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
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

      # choose only windows in current session
      bind-key -r -T prefix w run-shell 'tmux choose-tree -Nwf"##{==:##{session_name},#{session_name}}"'
      # choose both session and windows
      bind-key -r -T prefix S choose-window

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      set -g status off
      # set-hook -g after-new-window 'if "[ #{session_windows} -gt 1 ]" "set status on"'
      # set-hook -g after-kill-pane 'if "[ #{session_windows} -le 1 ]" "set status off"'
      bind b set-option -g status

      bind-key -n C-PageUp previous-window
      bind-key -n C-PageDown next-window
    '';
  };
}
