{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  users.users.porebski.extraGroups = [ "gamemode" ];

  environment.systemPackages = with pkgs; [
    (lutris.override {
      # Make the performance tools available inside Lutris's FHS environment.
      extraPkgs = pkgs: with pkgs; [
        gamemode
        mangohud
      ];
    })
    mangohud
  ];
}
