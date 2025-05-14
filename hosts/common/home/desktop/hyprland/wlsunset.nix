{ pkgs, ... }:
let
  latitude = 52.5200;
  longitude = 13.4050;
in {
  services.wlsunset = {
    enable = true;
    inherit latitude longitude;
    systemdTarget = "graphical-session.target";
  };
}
