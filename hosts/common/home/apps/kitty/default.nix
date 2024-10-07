{ pkgs, ... }:
{
  home.file.".config/kitty/scripts" = {
    source = ./config;
  };

  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+c" = "new_tab";
      "ctrl+shift+w" = "no_op";
    };
    settings = {

      background_opacity = "0.97";
      dynamic_background_opacity = "yes";
      font_family = "JetBrainsMono Nerd Font Mono";
      font_size = pkgs.lib.mkDefault 9;
      # https://github.com/kovidgoyal/kitty/issues/719#issuecomment-952039731
      # scrollback_pager = "bash -c \"exec nvim 63<&0 0</dev/null -u NONE -c 'map <silent> q :qa!<CR>' -c 'set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus' -c 'autocmd TermEnter * stopinsert' -c 'autocmd TermClose * call cursor(max([0,INPUT_LINE_NUMBER-1])+CURSOR_LINE, CURSOR_COLUMN)' -c 'terminal sed </dev/fd/63 -e \"s/'$'\x1b'']8;;file:[^\]*[\]//g\" && sleep 0.01 && printf \"'$'\x1b'']2;\"'\"";
      scrollback_pager = "$HOME/.config/kitty/scripts/scrollback_pager.sh 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";
      # NO BELLS!
      enable_audio_bell = "no";
      copy_on_select = "yes";
      enabled_layouts = "tall:bias=70, tall:bias=30, horizontal, stack";
      window_border_width = "1.0";
      window_margin_width = "0.0";
      single_window_margin_width = "0.0";

      tab_bar_margin_width = "1.0";
      tab_bar_style = "separator";
      tab_separator = " │ ";
      active_tab_font_style = "normal";
      inactive_tab_font_style = "normal";

      allow_remote_control = "yes";
      env = "PATH=/usr/local/bin:\$\{PATH\}";
      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "yes";
      macos_traditional_fullscreen = "yes";
      macos_show_window_title_in = "none";

      # map = f1 new_window_with_cwd
      # map f2 new_tab_with_cwd
    };
  };
}
