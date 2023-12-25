{
  description = "Przemek's NixOS Flake";

  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      # export NIXPKGS_ALLOW_UNFREE=1 && nix build .#homeConfigurations.porebski.activationPackage --impure --show-trace && ./result/activate
      homeConfigurations = {
        przemek = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home
          ];
        };
        porebski = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home
          ];
        };
      };
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
        let 
          user = "przemek";
        in 
        [
          ./configuration.nix
          nixos-hardware.nixosModules.dell-e7240

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home;
          }
        ];
      };
      nixosConfigurations.dooku = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
        let 
          user = "porebski";
        in 
        [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home;
          }
        ];
      };
    };
}
