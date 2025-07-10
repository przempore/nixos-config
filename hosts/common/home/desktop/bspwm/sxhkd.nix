{ lib, ... }: {

  home.file.".config/bspwm/scripts/bspwm_resize".text = ''
    #usr/bin/env dash
    if bspc query -N -n focused.floating > /dev/null; then
            step=20
    else
            step=100
    fi

    case "$1" in
            west) dir=right; falldir=left; x="-$step"; y=0;;
            east) dir=right; falldir=left; x="$step"; y=0;;
            north) dir=top; falldir=bottom; x=0; y="-$step";;
            south) dir=top; falldir=bottom; x=0; y="$step";;
    esac

    bspc node -z "$dir" "$x" "$y" || bspc node -z "$falldir" "$x" "$y"
  '';

  home.file.".config/bspwm/scripts/toggle_polybar" = {
    text = ''
      #usr/bin/env bash

      echo "[toggle_polybar] start" | systemd-cat

      state_file="$HOME/.cache/polybar_state"

      # Check if the state file exists
      if [ ! -f "$state_file" ]; then
          echo "visible" > "$state_file"
      fi

      # Read the current state
      current_state=$(cat "$state_file")

      # Toggle the state
      if [[ "$current_state" == "visible" ]]; then
          # Hide Polybar and adjust bspwm padding
          polybar-msg cmd hide
          bspc config top_padding 0
          echo "hidden" > "$state_file"
      else
          # Show Polybar and adjust bspwm padding
          polybar-msg cmd show
          bspc config top_padding 30
          echo "visible" > "$state_file"
      fi
      echo "[toggle_polybar] end" | systemd-cat
    '';
    executable = true;
  };

  services.sxhkd = {
    enable = true;
    keybindings = lib.mkDefault {
      #Rofi Fullscreen
      "super + F11" = "rofi -theme-str 'window \{width: 100%;height: 100%;\}' -show drun";
      #Rofi
      "alt + space" = "rofi -show drun -show-icons";
      #arcolinux-logout
      "super + x" = "archlinux-logout";
      #Rofi theme selector
      "super + r" = "rofi-theme-selector";
      #Pavucontrol
      "super + v" = "xfce4-popup-clipman";
      "super + Return" = "ghostty";
      # "super + Return" = "wezterm start --always-new-process";
      "super + Escape" = "xkill";
      # "super + KP_Enter" = "kitty";
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
      "ctrl + alt + shift + p" = "shutter -s";
      "ctrl + alt + m" = "xfce4-settings-manager";
      "ctrl + alt + r" = "rofi-theme-selector";
      "ctrl + alt + w" = "wezterm start --always-new-process";
      # "ctrl + alt + s" = "spotify";
      "ctrl + alt + v" = "pavucontrol";
      "ctrl + alt + a" = "xfce4-appfinder";
      #Wallpaper trash
      "alt + shift + t" = "variety -t && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&";
      #Wallpaper next
      "alt + shift + n" = "variety -n && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&";
      #Wallpaper previous
      "alt + shift + p" = "variety -p && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&";
      #Wallpaper favorite
      "alt + shift + f" = "variety -f && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&";
      #Wallpaper update
      "alt + shift + u" = "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&";
      #Xcfe4-TaskManager
      "ctrl + shift + Escape" = "xfce4-taskmanager";
      "alt + Up" = "~/.config/polybar/pavolume.sh --up";
      "alt + Down" = "~/.config/polybar/pavolume.sh --down";
      #Hide polybar
      "super + y" = "$HOME/.config/bspwm/scripts/toggle_polybar";
      #Picom Toggle
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
      #Reload bspwm
      "super + shift + x" = "betterlockscreen -l --dim";
      #kill
      "super + shift + q" = "bspc node -c";
      # Focus/swap windows by direction
      "super + {_,shift + }{h,j,k,n}" = "bspc node --{focus,swap} {west,south,north,east}";
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
      "super + ctrl + {h,j,k,n}" = "bspc node {@east -r -10,@north -r +10,@south -r -10,@west -r +10}";
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
      # "alt + k" = "$HOME/.config/bspwm/scripts/refresh-keyboard.sh";
      # "alt + c" = "$HOME/.config/bspwm/scripts/refresh-keyboard.sh --set_CTRL";
      # Expand tiled space
      "alt + shift + {h,j,k,n}" = "bspc node {@west -r -10,@south -r +10,@north -r -10,@east -r +10}";
      # Focus next/previous window
      # "ctrl + alt + Left" = "bspc node --focus west";
      # Focus next/previous window
      # "ctrl + alt + Right" = "bspc node --focus east";
      # Focus Up window
      # "ctrl + alt + Up" = "bspc node --focus north";
      # Focus Down window
      # "ctrl + alt + Down" = "bspc node --focus south";
      "super + {plus,bracketleft,braceleft,parenleft,ampersand,equal,parenright,braceright,bracketright,asterisk}" = "bspc desktop -f '^{1-9,10}'";
      # super + shift + {1-9,0}
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
  };
}
