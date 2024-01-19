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

    # set rdp_use_client_keymap=1 in ~/.config/remmina/remmina.pref
    packages = with pkgs; [
      remmina
      dbeaver
    ];
  };
}
