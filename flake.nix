{
  description = "Przemek's NixOS Flake";

  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    legacy-nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    mozilla-overlay.url = "github:mozilla/nixpkgs-mozilla";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nixos-hardware
    , mozilla-overlay
    , legacy-nixpkgs
    , ...
    }@inputs:
    let
      system = "x86_64-linux";

      myOverlays = [
        (import "${mozilla-overlay.outPath}/firefox-overlay.nix")
      ];
      pkgs = nixpkgs.legacyPackages.${system} // { overlays = myOverlays; };
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system} // { overlays = myOverlays; };
      legacyPkgs = legacy-nixpkgs.legacyPackages.${system};

      config = pkgs.config;
      allowed-unfree-packages = [
        "netflix-via-google-chrome"
        "netflix-icon"
        "discord"
        "google-chrome"
        "spotify"
        "obsidian"
      ];
      permittedInsecurePackages = [
        "nix-2.16.2"
        "electron-25.9.0"
      ];
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      # nix run '.?submodules=1#homeConfigurations.<configuration>.activationPackage' --show-trace --impure -- switch
      homeConfigurations = {
        arch_linux = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable; };
          modules = [
            ./hosts/arch_linux/home
          ];
        };
        przemek = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages; };
          modules = [
            ./hosts/dathomir/home
          ];
        };
        porebski = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages legacyPkgs; };
          modules = [
            ./hosts/dooku/home
          ];
        };
      };
      # sudo nixos-rebuild switch --flake '.?submodules=1#<host_name>' --show-trace
      nixosConfigurations = {
        dathomir = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = myOverlays; })
            ./hosts/dathomir/configuration.nix
            nixos-hardware.nixosModules.dell-e7240

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.przemek = ./hosts/dathomir/home;
              home-manager.extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable; };
            }
          ];
        };
        dooku = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [

            ({ config, pkgs, ... }: { nixpkgs.overlays = myOverlays; })
            ./hosts/dooku/configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.porebski = import ./hosts/dooku/home;
              home-manager.extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable legacyPkgs; };
            }
          ];
        };
      };
    };
}
