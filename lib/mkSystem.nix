{ inputs
, outputs
, nixpkgs
, ...
}: machine: { system
            , user
            ,
            }:
let
in {

  nixosConfigurations.${machine} = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      # ({ ... }: { nixpkgs.overlays = myOverlays; })
      ./hosts/ilum/configuration.nix
      inputs.lix-module.nixosModules.default
      ../modules/base.nix
      ../modules
      # unfree-config

      # home-manager.nixosModules.home-manager
      # {
      #   home-manager.useGlobalPkgs = true;
      #   home-manager.useUserPackages = true;
      #   home-manager.users.przemek = import ./hosts/ilum/home;
      #   home-manager.extraSpecialArgs = { inherit pkgs-unstable legacyPkgs catppuccin zen-browser tmux-sessionx; };
      # }
    ];
  };
}

