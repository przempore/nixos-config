{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop
    ../../common/home/apps/teleport.nix
    ../../common/home/apps/google-cloud.nix
    ../../common/home/apps/zed
    ../../common/home/desktop/hyprland
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
      pkgs.freerdp
      # pkgs.dbeaver-bin

      # pkgs-unstable.zoom-us
      # pkgs.rustdesk
      # pkgs-unstable.teams-for-linux
      pkgs-unstable.codex
      pkgs-unstable.claude-code
      pkgs.rclone
      pkgs.cups
    ];
  };
}
