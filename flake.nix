{
  description = "Przemek's NixOS Flake";

  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      config = pkgs.config;
      allowed-unfree-packages = [
        "netflix-via-google-chrome"
        "netflix-icon"
        "discord"
        "google-chrome"
        "spotify"
        "tabnine"
      ];
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      # nix build '.?submodules=1#homeConfigurations.porebski.activationPackage' --show-trace && ./result/activate
      homeConfigurations = {
        przemek = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit allowed-unfree-packages pkgs-unstable;};
          modules = [
            ./hosts/dathomir/home
          ];
        };
        porebski = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit allowed-unfree-packages pkgs-unstable;};
          modules = [
            ./hosts/dooku/home
          ];
        };
      };
      # sudo nixos-rebuild switch --flake '.?submodules=1#dooku' --show-trace
      nixosConfigurations = {
        dathomir = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/dathomir/configuration.nix
            nixos-hardware.nixosModules.dell-e7240

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.przemek = ./hosts/dathomir/home;
              home-manager.extraSpecialArgs = {inherit allowed-unfree-packages pkgs-unstable;};
            }
          ];
        };
        dooku = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/dooku/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.porebski = import ./hosts/dooku/home;
              home-manager.extraSpecialArgs = {inherit allowed-unfree-packages pkgs-unstable;};
            }
          ];
        };
      };
    };
}
