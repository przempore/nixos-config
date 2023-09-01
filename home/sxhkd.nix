{ config, pkgs, ... }: {
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + Return" = "kitty";
    };
  };
}
