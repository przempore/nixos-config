{ pkgs , ... }: {
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    # silent = true;
    # loadInNixShell = true;
    # direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
}
