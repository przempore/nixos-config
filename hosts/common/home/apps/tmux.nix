{ pkgs
, pkgs-unstable
, tmux-sessionx 
, ...
}: {
  programs.tmux = {
    enable = true;
    package = pkgs-unstable.tmux;
    shortcut = "a";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0; # Stop tmux+escape craziness.
    terminal = "tmux-256color";

    plugins = [
      {
        plugin = tmux-sessionx.packages.x86_64-linux.default;
        extraConfig = ''
          set -g @sessionx-bind "o"
          set-environment -gu TMUX_PLUGIN_MANAGER_PATH
        '';

      }
    ] ++ (with pkgs.tmuxPlugins; [
      better-mouse-mode
      {
          plugin = catppuccin;
          extraConfig = '' 
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_date_time "%H:%M"
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
    ]);

    extraConfig = ''
      # vi is good
      bind-key -T copy-mode-vi 'v' send -X begin-selection     # Begin selection in copy mode.
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle  # Begin selection in copy mode.
      bind-key -T copy-mode-vi 'y' send -X copy-selection      # Yank selection in copy mode.

      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # choose only windows in current session
      bind-key -r -T prefix w run-shell 'tmux choose-tree -Nwf"##{==:##{session_name},#{session_name}}"'
      # choose both session and windows
      bind-key -r -T prefix S choose-window

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
