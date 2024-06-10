function get_location {
  location=$(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | jq -r '"\(.location.lat):\(.location.lng)"')
  if [ -z $location ]; then
      location="52.5196:13.4069"
      echo "[bspwm autostart] no internet connection, setting location to Berlin [$location" | systemd-cat
  fi
  echo "[bspwm autostart] location for redshift: $location" | systemd-cat
}

polybar mainbar 2>/dev/null &
feh --bg-scale $HOME/Projects/dotfiles/screenlayout/.screenlayout/deep_blue_Original.png
keepassxc &
blueberry-tray &
xfce4-clipman &
nm-applet &
get_location
redshift -l $location &
xfce4-power-manager &

firefox &

# whatsapp-nativefier &
signal-desktop &
