{ inputs
, outputs
, ...
}: machine: { system
            , user
            ,
            }:
let
  myOverlays = [
    (import "${inputs.mozilla-overlay.outPath}/firefox-overlay.nix")
  ];
  pkgs = inputs.nixpkgs.legacyPackages.${system} // { overlays = myOverlays; };
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${system} // { overlays = myOverlays; };
  home = {
    extraSpecialArgs = {
      inherit inputs outputs pkgs-unstable;
      allowed-unfree-packages = inputs.allowed-unfree-packages;
      permittedInsecurePackages = inputs.permittedInsecurePackages;
      catppuccin = inputs.catppuccin;
      zen-browser = inputs.zen-browser;
      tmux-sessionx = inputs.tmux-sessionx;
    };
  };
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
    "python3.11-youtube-dl-2021.12.17"
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
  nixosConfigurations.${machine} = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs outputs;
    };

    modules = [
      # ({ ... }: { nixpkgs.overlays = myOverlays; })
      ../hosts/${machine}/configuration.nix
      inputs.lix-module.nixosModules.default
      ../modules
      # outputs.unfree-config
      {
        # Extra arguments I can import into any modules
        _module.args = { inherit pkgs-unstable; };
      }
    ];
  };

  homeConfigurations.${user} = inputs.home-manager.lib.homeManagerConfiguration (
    home
    // {
      inherit pkgs pkgs-unstable;
      modules = [
        ./hosts/${machine}/home
        inputs.lix-module.nixosModules.default

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./hosts/${machine}/home;
        }
      ];
    }
  );
}
