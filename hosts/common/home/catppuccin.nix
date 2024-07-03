{ catppuccin, ... }: {
  imports = [
    catppuccin.homeManagerModules.catppuccin
  ] ++ (if builtins.pathExists ./private/default.nix then [ ./private ] else [ ]);
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "pink";
    pointerCursor = {
      enable = true;
      accent = "dark";
    };
  };
}
