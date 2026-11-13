{ pkgs-unstable, ... }:
{
  programs.discord = {
    enable = true;
    package = pkgs-unstable.discord;
    settings = {
      SKIP_HOST_UPDATE = true;
      SKIP_MODULE_UPDATE = true;
    };
  };
}
