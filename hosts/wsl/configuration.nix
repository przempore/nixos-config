{ pkgs, ... }: {

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "przemek";
    startMenuLaunchers = true;
  };

  nix = {
    # package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  system.stateVersion = "23.05";
}
