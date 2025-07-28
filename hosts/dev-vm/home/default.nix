{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop/bspwm
    ../../common/home/desktop/gtk.nix
    ../../common/home/desktop/screen_settings
  ];

  # VM-specific home configuration
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";

    packages = [
      pkgs.remmina
      pkgs.freerdp3
      pkgs.rclone
    ];
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

  home.file.".config/bspwm/scripts/refresh_keyboard" = {
    text = ''
      setxkbmap -option ctrl:nocaps
    '';
    executable = true;
  };

  xsession.windowManager.bspwm = {
    enable = true;
    extraConfig = lib.mkDefault ''
      echo "[bspwm dev-vm autostart] starting" | systemd-cat

      # home LG
      xrandr --newmode "3840x1600_60.00"  521.75  3840 4128 4544 5248  1600 1603 1613 1658 -hsync +vsync
      xrandr --addmode Virtual-1 3840x1600_60.00

      # office Phillips
      xrandr --newmode "3440x1440_60.00"  419.50  3440 3696 4064 4688  1440 1443 1453 1493 -hsync +vsync
      xrandr --addmode Virtual-1 3440x1440_60.00

      autorandr --change | systemd-cat -p info

      feh --bg-fill $HOME/.background-image

      run $HOME/.config/bspwm/scripts/refresh_keyboard

      echo "[bspwm dev-vm autostart] finished" | systemd-cat
    '';
  };

  services.sxhkd = {
    enable = true;
    keybindings = lib.mkDefault {
      # # Focus/swap windows by direction
      "super + {_,shift + }{h,j,k,n}" = "bspc node --{focus,swap} {west,south,north,east}";
      # Contract tiled space
      "super + ctrl + {h,j,k,n}" = "bspc node {@east -r -10,@north -r +10,@south -r -10,@west -r +10}";
      # Expand tiled space
      "alt + shift + {h,j,k,n}" = "bspc node {@west -r -10,@south -r +10,@north -r -10,@east -r +10}";
    };
  };

  programs.git = {
    userEmail = "porebski@adlares.com";
    userName = "Przemyslaw Porebski";
    extraConfig = lib.mkDefault {
      credential.helper = "store";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with.
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
