{ ... }:
{
  services.geoclue2.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
  };
}
