{ ... }:
{
  # source https://github.com/ttys3/my-ghostty-config/tree/main

  home.file.".config/ghostty/tab-style.css".text = ''
    /*
    debug: env GTK_DEBUG=interactive ghostty
    https://docs.gtk.org/gtk4/css-overview.html
    https://docs.gtk.org/gtk4/css-properties.html
    */


    headerbar {
      min-height: 24px;
      padding: 0;
      margin: 0;
    }

    tabbar tabbox {
      margin: 0;
      padding: 0;
      min-height: 10px;
      background-color: #1a1a1a;
      font-family: monospace;
    }

    tabbar tabbox tab {
      margin: 0;
      padding: 0;
      color: #9ca3af;
      border-right: 1px solid #374151;
    }

    tabbar tabbox tab:selected {
      background-color: #2d2d2d;
      color: #ffffff;
    }

    tabbar tabbox tab label {
      font-size: 13px;
    }
  '';

  home.file.".config/ghostty/config".text = ''
    theme = catppuccin-mocha
    gtk-custom-css = tab-style.css

    font-family = "JetBrainsMono Nerd Font Mono"
    font-size = 10
    # window-decoration = false
    # gtk-tabs-location = hidden

    adjust-cell-width = -15%
    adjust-cell-height = -15%

    gtk-wide-tabs = false
    gtk-tabs-location = bottom
    gtk-titlebar = false

    window-theme = ghostty

    keybind = ctrl+;>q=close_window
    keybind = ctrl+;>w=toggle_tab_overview
    keybind = ctrl+;>shift+r=reload_config
    keybind = ctrl+;>x=close_surface
    keybind = ctrl+shift+h=write_scrollback_file:open
    keybind = ctrl+alt+shift+i=write_screen_file:open
  '';

  home.file.".local/share/applications/nvim.desktop".text = ''
    [Desktop Entry]
    Name=Neovim
    Categories=Utility;TextEditor;
    Comment=Neovim Text Editor
    Exec=ghostty -e nvim %F
    Icon=gvim
    Keywords=Text;editor;
    MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
    StartupNotify=false
    Terminal=false
    Type=Application
  '';
}
