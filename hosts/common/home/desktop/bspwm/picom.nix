{ lib
, ...
}: {
  services.picom.enable = lib.mkDefault true;
  services.picom.settings = {
    shadow = true;
    shadow-radius = 7;
    shadow-offset-x = -7;
    shadow-offset-y = -7;
    shadow-exclude = [
      "name = 'Notification'"
      "class_g ?= 'Notify-osd'"
      "name = 'Plank'"
      "name = 'Docky'"
      "name = 'Kupfer'"
      "name = 'xfce4-notifyd'"
      "name *= 'VLC'"
      "name *= 'compton'"
      "name *= 'Chromium'"
      "name *= 'Chrome'"
      "class_g = 'Firefox' && argb"
      "class_g = 'Conky'"
      "class_g = 'Kupfer'"
      "class_g = 'Synapse'"
      "class_g ?= 'Notify-osd'"
      "class_g ?= 'Cairo-dock'"
      "class_g = 'Cairo-clock'"
      "class_g ?= 'Xfce4-notifyd'"
      "class_g ?= 'Xfce4-power-manager'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    fade = lib.mkDefault true;
    fade-in-step = 0.04;
    fade-out-step = 0.04;
    fade-delta = 4;
    inactive-opacity = 1;
    frame-opacity = 0.95;
    inactive-opacity-override = true;
    focus-exclude = [ "class_g = 'Cairo-clock'" ];
    opacity-rule = [ "80:class_g = 'Alacritty'" ];
    blur-kern = "3x3box";
    # blur-background-exclude = [
    #   "window_type = 'dock'";
    #   "window_type = 'desktop'";
    #   "_GTK_FRAME_EXTENTS@:c"
    # ];
    # backend = "glx";
    vsync = lib.mkDefault false;
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    corner-radius = 10;
    rounded-corners-exclude = [ "class_g = 'Roffi'" ];
    detect-rounded-corners = true;
    detect-client-opacity = true;
    refresh-rate = 0;
    detect-transient = true;
    detect-client-leader = true;
    use-damage = true;
    log-level = "warn";
    # wintypes:
    # {
    #   tooltip = { fade = true; shadow = true; opacity = 0.9; focus = true; full-shadow = false; };
    #   dock = { shadow = false; }
    #   dnd = { shadow = false; }
    #   popup_menu = { opacity = 0.9; }
    #   dropdown_menu = { opacity = 0.9; }
    # };
  };

}
