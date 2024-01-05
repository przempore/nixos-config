{ config, pkgs, user, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/teleport.nix
    ../../common/home/google-cloud.nix
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home = {
    username = "porebski";
    homeDirectory = "/home/porebski";

    packages = with pkgs; [
      remmina
      dbeaver
    ];
  };
}
