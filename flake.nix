{
  description = "Przemek's NixOS Flake";

  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    legacy-nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    mozilla-overlay.url = "github:mozilla/nixpkgs-mozilla";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:ch4og/zen-browser-flake";
    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
      mkSystem = import ./lib/mkSystem.nix { inherit inputs outputs; };
    in
    (mkSystem "ilum" {
      inherit system;
      user = "przemek";
    }) //
    {
      # formatter.${system} = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      # formatter.${system} = {pkgs}: pkgs.alejandra;
      devShells.${system} = ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            lua
            luajit
            lua-language-server
            stylua
            nixd
            alejandra
          ];
        };
      }
      );

      # nix run '.?submodules=1#homeConfigurations.<configuration>.activationPackage' --show-trace --impure -- switch
      # using `nh`
      # nh home switch --backup-extension backup_$(date +"%Y%M%H%M%S") '.?submodules=1' -- --show-trace --impure
      # homeConfigurations = {
      #   ilum = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages catppuccin zen-browser tmux-sessionx; };
      #     modules = [
      #       ./hosts/ilum/home
      #       lix-module.nixosModules.default
      #     ];
      #   };
      #   przemek = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages catppuccin zen-browser tmux-sessionx; };
      #     modules = [
      #       ./hosts/dathomir/home
      #       lix-module.nixosModules.default
      #     ];
      #   };
      #   porebski = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages legacyPkgs catppuccin zen-browser tmux-sessionx; };
      #     modules = [
      #       ./hosts/dooku/home
      #       lix-module.nixosModules.default
      #     ];
      #   };
      # };
      # sudo nixos-rebuild switch --flake '.?submodules=1#<host_name>' --show-trace --impure
      # using nh
      # nh os switch --update '.?submodules=1' -- --impure --show-trace
      # nixosConfigurations = {
      #   dathomir = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ({ ... }: { nixpkgs.overlays = myOverlays; })
      #       ./hosts/dathomir/configuration.nix
      #       nixos-hardware.nixosModules.dell-e7240
      #       lix-module.nixosModules.default
      #       unfree-config
      #
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.przemek = ./hosts/dathomir/home;
      #         home-manager.extraSpecialArgs = { inherit allowed-unfree-packages pkgs-unstable catppuccin zen-browser tmux-sessionx; };
      #       }
      #     ];
      #   };
      #   dooku = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ({ ... }: { nixpkgs.overlays = myOverlays; })
      #       ./hosts/dooku/configuration.nix
      #       nixos-hardware.nixosModules.lenovo-thinkpad
      #       lix-module.nixosModules.default
      #       unfree-config
      #
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.porebski = import ./hosts/dooku/home;
      #         home-manager.extraSpecialArgs = { inherit pkgs-unstable legacyPkgs catppuccin zen-browser tmux-sessionx; };
      #       }
      #     ];
      #   };
      #   ilum = nixpkgs.lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ({ ... }: { nixpkgs.overlays = myOverlays; })
      #       ./hosts/ilum/configuration.nix
      #       ./modules
      #       lix-module.nixosModules.default
      #       unfree-config
      #
      #       home-manager.nixosModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.users.przemek = import ./hosts/ilum/home;
      #         home-manager.extraSpecialArgs = { inherit pkgs-unstable legacyPkgs catppuccin zen-browser tmux-sessionx; };
      #       }
      #     ];
      #   };
      # };
    };
}
