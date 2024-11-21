{ lib, ... }:
{
  imports = [
    ../../common/home
    ../../common/home/desktop
  ];

  # Packages that should be installed to the user profile.
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";

    pointerCursor = {
      size = 6;
    };
    # used with closed nvidia drivers
    # sessionVariables = {
    #   NVD_BACKEND = "direct";
    #   LIBVA_DRIVER_NAME = "nvidia";
    # };
  };

  services.picom.settings = {
    vsync = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  xsession.windowManager.bspwm = {
    extraConfig = ''
      echo "[bspwm autostart] starting" | systemd-cat

      autorandr --load default

      bspc monitor -d 1 2 3 4 5 6 7 8 9 10

      function run {
        if ! pgrep $1 ;
        then
          $@&
        fi
      }

      run $HOME/.config/polybar/launcher.sh

      run keepassxc
      run blueman-applet
      run xfce4-clipman
      run nm-applet
      run xfce4-power-manager

      echo "[bspwm autostart] finished" | systemd-cat
    '';
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
