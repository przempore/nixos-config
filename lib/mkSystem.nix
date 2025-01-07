{ inputs, ... }:
{ machine, system, nixos-hardware ? null, user }:
let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  legacyPkgs = inputs.legacy-nixpkgs.legacyPackages.${system};

  allowed-unfree-packages = [
    "netflix-via-google-chrome"
    "netflix-icon"
    "discord"
    "google-chrome"
    "spotify"
    "obsidian"
    # "vscode-extension-ms-vscode-cpptools"
  ];
  permittedInsecurePackages = [
    "nix-2.16.2"
    "electron-25.9.0"
  ];
  unfree-config = { lib, ... }: {
    options.permittedInsecurePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = permittedInsecurePackages;
    };
    options.allowed-unfree-packages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = allowed-unfree-packages;
    };
  };
in
{
  homeConfiguration = {
    ${user} = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages legacyPkgs;
        catppuccin = inputs.catppuccin;
        zen-browser = inputs.zen-browser;
        tmux-sessionx = inputs.tmux-sessionx;
        ghostty = inputs.ghostty;
      };
      modules = [
        # TODO: move modules around to unlock home configuration from machine
        ../hosts/${machine}/home
        inputs.lix-module.nixosModules.default
      ];
    };
  };

  nixosConfiguration = {
    ${machine} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = inputs.nixpkgs.lib.optional (nixos-hardware != null) nixos-hardware ++ [
        unfree-config
        ../hosts/${machine}/configuration.nix
        inputs.lix-module.nixosModules.default

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = ../hosts/${machine}/home;
          home-manager.extraSpecialArgs = {
            inherit allowed-unfree-packages pkgs-unstable legacyPkgs;
            catppuccin = inputs.catppuccin;
            zen-browser = inputs.zen-browser;
            tmux-sessionx = inputs.tmux-sessionx;
            ghostty = inputs.ghostty;
          };
        }
      ];
    };
  };
}
