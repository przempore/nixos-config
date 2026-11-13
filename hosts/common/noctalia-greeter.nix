{ config, pkgs, pkgs-unstable, ... }:
let
  greeter = pkgs-unstable.noctalia-greeter;
  greeterConfig = (pkgs.formats.toml { }).generate "noctalia-greeter.toml" {
    session.default = config.services.displayManager.defaultSession;
    appearance = {
      scheme = "Catppuccin";
      wallpaper = {
        path = "${./home/desktop/screen_settings/wallpaper/nature_of_fear_Nicola_Samori.jpg}";
        fill_mode = "crop";
      };
    };
    keyboard = {
      inherit (config.services.xserver.xkb) layout variant options;
    };
  };
in
{
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager = {
    sddm.enable = false;
    defaultSession = "hyprland-uwsm";
  };
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      # greetd starts with a minimal environment; expose custom layouts and sessions.
      command = "${pkgs.coreutils}/bin/env XKB_CONFIG_ROOT=${config.services.xserver.xkb.dir} XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share ${greeter}/bin/noctalia-greeter-session";
    };
  };
  services.accounts-daemon.enable = true;
  security.polkit.enable = true;
  environment.systemPackages = [ greeter pkgs.xinit ];
  systemd.tmpfiles.rules = [
    "d /var/lib/noctalia-greeter 0750 greeter greeter -"
    "L+ /var/lib/noctalia-greeter/greeter.toml - - - - ${greeterConfig}"
  ];
}
