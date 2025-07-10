{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop
  ];

  # VM-specific home configuration
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";
  };

  services.picom = {
    enable = false;
    settings = {
      backend = "xrender";
      fade = false;
      # shadow = false;
      blur = false;
      vsync = false;
    };
  };

  xsession.windowManager.bspwm = {
    enable = true;
    extraConfig = lib.mkDefault ''
      echo "[bspwm autostart] starting" | systemd-cat

      setxkbmap -option ctrl:nocaps
      setxkbmap -option altwin:swap_lalt_lwin

      # home LG
      xrandr --newmode "3840x1600_60.00"  521.75  3840 4128 4544 5248  1600 1603 1613 1658 -hsync +vsync
      xrandr --addmode Virtual-1 3840x1600_60.00

      # office Phillips
      xrandr --newmode "3440x1440_60.00"  419.50  3440 3696 4064 4688  1440 1443 1453 1493 -hsync +vsync
      xrandr --addmode Virtual-1 3440x1440_60.00

      autorandr --change | systemd-cat -p info

      function run {
        if ! pgrep $1 ;
        then
          $@&
        fi
      }

      run $HOME/.config/polybar/launcher.sh

      run keepassxc
      run xfce4-clipman
      run nm-applet

      echo "[bspwm autostart] finished" | systemd-cat
    '';
  };

  services.sxhkd.keybindings = {
      #Rofi
      "alt + space" = "rofi -show drun -show-icons";
      #Rofi theme selector
      "super + r" = "rofi-theme-selector";

      "super + Return" = "kitty";
      "super + Escape" = "xkill";
      "super + KP_Enter" = "wezterm start --always-new-process";
      #File-Manager
      "super + shift + Return" = "thunar";
      #dmenu
      "super + m" = "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'";
      #reload sxhkd:
      "alt + r" = "pkill -USR1 -x sxhkd";

      "ctrl + alt + g" = "brave";
      "ctrl + alt + f" = "firefox-nightly";
      "ctrl + alt + z" = "zen";
      "ctrl + alt + k" = "keepassxc";
      "ctrl + alt + p" = "flameshot gui";
      "ctrl + alt + m" = "xfce4-settings-manager";
      "ctrl + alt + w" = "wezterm start --always-new-process";
      # "ctrl + alt + s" = "spotify";
      "ctrl + alt + a" = "xfce4-appfinder";
      #Xcfe4-TaskManager
      "ctrl + shift + Escape" = "xfce4-taskmanager";
      #Hide polybar
      "super + y" = "$HOME/.config/bspwm/scripts/toggle_polybar";

      "ctrl + alt + o" = "obsidian";
      #Toggle fullscreen of window
      "super + f" = "bspc node --state \~fullscreen";
      # Toggle pseudo tiling of window
      "super + p" = "bspc node --state \~pseudo_tiled";
      "super + o" = "bspc node --state \~floating";
      #kill
      "super + q" = "bspc node -c";
      # Rotate windows layout
      "super + {_,shift + }e" = "bspc node '@parent' -R {_,-}90";
      #Focus selected desktop
      "super + Tab" = "rofi -show window -show-icons";
      # set the window state
      "super + space" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      # Move focus to other monitor
      "super + BackSpace" = "bspc monitor -f next";
      # Move floating window
      "super + alt + {_,shift + }{Left,Down,Up,Right}" = "~/.config/bspwm/scripts/move-window {_,edge-}{west,south,north,east}";
      # Cancel preselection
      "super + ctrl + space" = "bspc node --presel-dir cancel";
      #kill
      "super + shift + q" = "bspc node -c";
      # Focus/swap windows by direction
      "super + {_,shift + }{h,j,k,l}" = "bspc node --{focus,swap} {west,south,north,east}";
      # Flip layout vertically/horizontally
      "super + {_,shift + }a" = "bspc node @/ --flip {vertical,horizontal}";
      # Move focused window to other monitor
      "super + shift + Left" = "bspc node -m next --follow";
      # Move focused window to other monitor
      "super + shift + Right" = "bspc node -m next --follow";
      # Move focused window to other monitor
      "super + shift + Up" = "bspc node -m next --follow";
      # Move focused window to other monitor
      "super + shift + Down" = "bspc node -m next --follow";
      # Focus/swap windows by direction
      # "super + ctrl + {Left,Down,Up,Right}" =  "bspc node --{focus} {west,south,north,east}";
      # Contract tiled space
      "super + ctrl + {h,j,k,l}" = "bspc node {@east -r -10,@north -r +10,@south -r -10,@west -r +10}";
      # Focus parent/brother/first/second for preselection
      "super + ctrl + {comma,period,p,y}" = "bspc node --focus @{parent,brother,first,second}";
      # Preselect the splitting area for next window on leaf/parent
      "super + ctrl + {f,g,c,r}" = "bspc node --presel-dir \~{west,south,north,east}";
      # Define splitting ratio for next window on leaf/parent
      "super + ctrl + {_,shift +}{plus,bracketleft,braceleft,parenleft,ampersand,equal,parenright,braceright,bracketright,asterisk}" = "bspc node {_,@/} --presel-ratio 0.{1-9}";
      #Focus selected desktop
      "alt + Tab" = "bspc desktop -f '^{1-9,10}'";
      #Focus selected desktop
      "alt + shift + Tab" = "bspc desktop -f '^{1-9,10}'";
      # Expand tiled space
      "alt + shift + {h,j,k,l}" = "bspc node {@west -r -10,@south -r +10,@north -r -10,@east -r +10}";

      "super + {plus,bracketleft,braceleft,parenleft,ampersand,equal,parenright,braceright,bracketright,asterisk}" = "bspc desktop -f '^{1-9,10}'";
      "super + shift + {plus,bracketleft,braceleft,parenleft,ampersand,equal,parenright,braceright,bracketright,asterisk}" = "bspc node -d '^{1-9,10}' -f";
      "super + {_, shift +} g" = "{ bspc config -d focused window_gap (math (bspc config -d focused window_gap) + 2); \
                                  [ $(bspc config -d focused window_gap) -ge 2 ] && \
                                  bspc config -d focused window_gap (math (bspc config -d focused window_gap) - 2); \
                                  };";
      # move a floating window
      "super + ctrl + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0};";
      # Custom move/resize
      "super + alt + {Left,Down,Up,Right}" = "$HOME/.config/bspwm/scripts/bspwm_resize {west,south,north,east};";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
