{ ... }: {
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
      tweaks = [ "rimless" ];
      icon = {
        enable = true;
        accent = "pink";
        flavor = "macchiato";
      };
    };
  };
}
