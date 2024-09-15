{ ... }:
{
  xdg.configFile."kitty/scripts/scrollback_pager.sh".source = ../../common/home/apps/kitty/config/scrollback_pager.sh;
  xdg.configFile."kitty/kitty.conf".text = ''
    include ./theme.conf

    background_opacity 0.95
    dynamic_background_opacity yes

    font_family JetBrainsMono NFM Regular

    font_size 9

    scrollback_pager ~/.config/kitty/scrollback_pager.sh 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'

      # NO BELLS!
    enable_audio_bell no

    copy_on_select yes

    enabled_layouts tall:bias=70, tall:bias=30, horizontal, stack

    window_border_width 1.0
    window_margin_width 0.0
    single_window_margin_width 0.0

    tab_bar_margin_width 1.0
    tab_bar_style separator
    tab_separator " │ "
    active_tab_font_style   normal
    inactive_tab_font_style normal

    allow_remote_control yes
    macos_option_as_alt left
    macos_quit_when_last_window_closed yes
    macos_traditional_fullscreen yes
    macos_show_window_title_in none

    map f1 new_window_with_cwd
    map f2 new_tab_with_cwd
    map ctrl+shift+c new_tab
    '';

  xdg.configFile."kitty/theme.conf".text = ''
    # The basic colors
    foreground              #CDD6F4
    background              #1E1E2E
    selection_foreground    #1E1E2E
    selection_background    #F5E0DC

    # Cursor colors
    cursor                  #F5E0DC
    cursor_text_color       #1E1E2E

    # URL underline color when hovering with mouse
    url_color               #F5E0DC

    # Kitty window border colors
    active_border_color     #B4BEFE
    inactive_border_color   #6C7086
    bell_border_color       #F9E2AF

    # OS Window titlebar colors
    wayland_titlebar_color system
    macos_titlebar_color system

    # Tab bar colors
    active_tab_foreground   #11111B
    active_tab_background   #CBA6F7
    inactive_tab_foreground #CDD6F4
    inactive_tab_background #181825
    tab_bar_background      #11111B

    # Colors for marks (marked text in the terminal)
    mark1_foreground #1E1E2E
    mark1_background #B4BEFE
    mark2_foreground #1E1E2E
    mark2_background #CBA6F7
    mark3_foreground #1E1E2E
    mark3_background #74C7EC

    # The 16 terminal colors

    # black
    color0 #45475A
    color8 #585B70

    # red
    color1 #F38BA8
    color9 #F38BA8

    # green
    color2  #A6E3A1
    color10 #A6E3A1

    # yellow
    color3  #F9E2AF
    color11 #F9E2AF

    # blue
    color4  #89B4FA
    color12 #89B4FA

    # magenta
    color5  #F5C2E7
    color13 #F5C2E7

    # cyan
    color6  #94E2D5
    color14 #94E2D5

    # white
    color7  #BAC2DE
    color15 #A6ADC8
    '';
}
