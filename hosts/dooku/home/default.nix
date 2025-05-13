{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop
    ../../common/home/apps/teleport.nix
    ../../common/home/apps/google-cloud.nix
    ../../common/home/desktop/hyprland
    ../../common/home/desktop/waybar
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
    packages = [
      pkgs.remmina
      pkgs.freerdp3
      pkgs.dbeaver-bin
      # pkgs-unstable.zed-editor

      pkgs-unstable.zoom-us
      pkgs.rustdesk
      pkgs.teams-for-linux
      pkgs.rclone
      pkgs.cups
    ];
  };
}
