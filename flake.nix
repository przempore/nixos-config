{
  description = "Przemek's NixOS Flake";

  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    legacy-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    mozilla-overlay.url = "github:mozilla/nixpkgs-mozilla";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { nixpkgs
    , nixos-hardware
    , ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkSystem = import ./lib/mkSystem.nix { inherit inputs; };
      dookuSystem = mkSystem {
        inherit system;
        machine = "dooku";
        user = "porebski";
        nixos-hardware = nixos-hardware.nixosModules.lenovo-thinkpad;
      };
      dathomirSystem = mkSystem {
        inherit system;
        machine = "dathomir";
        user = "przemek";
        nixos-hardware = nixos-hardware.nixosModules.dell-e7240;
      };
      ilumSystem = mkSystem {
        inherit system;
        machine = "ilum";
        user = "przemek";
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # nix run '.?submodules=1#homeConfigurations.<configuration>.activationPackage' --show-trace --impure -- switch
      # using `nh`
      # nh home switch --backup-extension backup_$(date +"%Y%M%H%M%S") '.?submodules=1' -- --show-trace --impure
      homeConfigurations = {
        ilum = ilumSystem.homeConfiguration.ilum;
        przemek = dathomirSystem.homeConfiguration.przemek;
        porebski = dookuSystem.homeConfiguration.porebski;
      };

      # sudo nixos-rebuild switch --flake '.?submodules=1#<host_name>' --show-trace --impure
      # using nh
      # nh os switch --update '.?submodules=1' -- --impure --show-trace
      nixosConfigurations = {
        dathomir = dathomirSystem.nixosConfiguration.dathomir;
        dooku = dookuSystem.nixosConfiguration.dooku;
        ilum = ilumSystem.nixosConfiguration.ilum;
      };
    };
}
