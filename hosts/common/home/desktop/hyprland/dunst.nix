{ pkgs, ... }:

let
  catppuccinDunst = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "dunst";
    rev = "5955cf0213d14a3494ec63580a81818b6f7caa66";
    sha256 = "sha256-rBp9wU6QHpmNAjeaKnI6u8rOUlv8MC70SLUzeKHN/eY=";
  };
in {
  services.dunst = {
    enable = true;
    configFile = "${catppuccinDunst}/themes/mocha.conf";
  };
}

