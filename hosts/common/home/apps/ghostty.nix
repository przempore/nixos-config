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

    keybind = ctrl+;>w=toggle_tab_overview

    # Close window (kitty close_os_window)
    keybind = ctrl+q=close_window

    # Toggle the tab overview, only works with libadwaita enabled
    keybind = ctrl+;>w=toggle_tab_overview

    keybind = ctrl+;>shift+r=reload_config
    keybind = ctrl+;>x=close_surface

    gtk-custom-css = tab-style.css
  '';
}
