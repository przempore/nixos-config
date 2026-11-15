{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../common/home
    ../../common/home/desktop
    ../../common/niri/home.nix
    ../../common/home/apps/teleport.nix
    ../../common/home/apps/google-cloud.nix
    ../../common/home/apps/zed.nix
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
    packages = with pkgs-unstable; [
      claude-code
      claude-agent-acp
      opencode
      pkgs-codex.codex
      pkgs-codex.codex-acp

      obs-studio
      # pkgs-unstable.zoom-us
    ] ++ (with pkgs; [
      remmina
      freerdp
      # dbeaver-bin

      # rustdesk
      unstable.teams-for-linux
      rclone
      cups
    ]);
  };
}
