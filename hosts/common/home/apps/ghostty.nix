{ pkgs-unstable, ghostty, ... }:
let
  catppuccin-ghostty = pkgs-unstable.fetchFromGitHub {
    owner = "catppuccin";
    repo  = "ghostty";
    rev   = "main";
    sha256 = "sha256-4seUhPr6nv0ld9XMrQS4Ko9QnC1ZOEiRjENSfgHIvR0=";
  };
in
{
  home.packages = [
    ghostty.packages.x86_64-linux.default
    # pkgs-unstable.ghostty

  ];

  xdg.configFile."ghostty/themes".source = "${catppuccin-ghostty}/themes";

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
    theme = catppuccin-mocha.conf
    gtk-custom-css = tab-style.css

    font-family = "JetBrainsMono Nerd Font Mono"
    font-size = 12
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
    keybind = alt+*=goto_tab:0
    keybind = alt++=goto_tab:1
    keybind = alt+[=goto_tab:2
    keybind = alt+{=goto_tab:3
    keybind = alt+(=goto_tab:4
    keybind = alt+&=goto_tab:5
    keybind = ctrl+enter=ignore


    # Vim-mode keybindings for Ghostty.
    #
    # Note: We're missing a number of actions to produce a better vim experience.
    # This is what is possible today! But we plan on adding more actions to make
    # this even better in the future.
    
    # Entry point
    keybind = alt+v=activate_key_table:vim
    
    # Key table definition
    keybind = vim/
    
    # Line movement
    keybind = vim/j=scroll_page_lines:1
    keybind = vim/k=scroll_page_lines:-1
    
    # Page movement
    keybind = vim/ctrl+d=scroll_page_down
    keybind = vim/ctrl+u=scroll_page_up
    keybind = vim/ctrl+f=scroll_page_down
    keybind = vim/ctrl+b=scroll_page_up
    keybind = vim/shift+j=scroll_page_down
    keybind = vim/shift+k=scroll_page_up
    
    # Jump to top/bottom
    keybind = vim/g>g=scroll_to_top
    keybind = vim/shift+g=scroll_to_bottom
    
    # Search (if you want vim-style search entry)
    keybind = vim/slash=start_search
    keybind = vim/n=navigate_search:next
    
    # Copy mode / selection
    # Note we're missing a lot of actions here to make this more full featured.
    keybind = vim/v=copy_to_clipboard
    keybind = vim/y=copy_to_clipboard
    
    # Command Palette
    keybind = vim/shift+semicolon=toggle_command_palette
    
    # Exit
    keybind = vim/escape=deactivate_key_table
    keybind = vim/q=deactivate_key_table
    keybind = vim/i=deactivate_key_table
    
    # Catch unbound keys
    keybind = vim/catch_all=ignore
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
