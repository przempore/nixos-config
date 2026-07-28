{ pkgs-unstable
, ...
}: {
  home.packages = with pkgs-unstable; [
    herdr
  ];

  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [ui.sound]
    enabled = false

    [keys]
    prefix = "ctrl+a"
  '';

}
