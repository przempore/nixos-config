{
  description = "Przemek's NixOS Flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    legacy-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # mozilla-overlay.url = "github:mozilla/nixpkgs-mozilla"; # not used anymore
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    # lix-module = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    tmux-sessionx = {
      url = "github:omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    deploy-rs.url = "github:serokell/deploy-rs";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    nixai.url = "github:olafkfreund/nix-ai-help";

    # Use local path for development, switch to GitHub URL for production
    # nvim-config.url = "path:/home/przemek/Projects/nvim-config";
    nvim-config.url = "github:przempore/nvim-config";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, flake-parts, nixos-hardware, deploy-rs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { system, pkgs, ... }: {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          buildInputs = (with pkgs; [
            # Essential tools for NixOS config management
            gnumake
            git
            openssh
            rsync

            # Nix development tools (moved from global installation)
            nixpkgs-fmt
            nil # Nix LSP (removed from nvim global, only needed for NixOS development)
            nixd
            nix-tree
            nix-output-monitor # nom (moved from global home packages)
            nh # Nix helper (moved from global home packages)

            # System utilities
            curl
            wget
            jq
            tree
            htop

            # Network tools for VM management
            netcat
            nmap
            inetutils # for telnet
          ]) ++ [
            # Deployment tools
            inputs.deploy-rs.packages.${system}.deploy-rs # for remote NixOS deployments
          ];

          shellHook = ''
            echo ""
            echo "🎯 NixOS Configuration Development Environment"
            echo "============================================="
            echo ""
            echo "Available commands:"
            echo "  make help          - Show all Makefile commands"
            echo "  make vm/setup-help - VM setup instructions"
            echo "  make switch        - Switch local NixOS config"
            echo "  make home-switch   - Switch home-manager config"
            echo "  make vm/switch     - Switch VM config (needs NIXADDR)"
            echo ""
            echo "Development tools available:"
            echo "  nixpkgs-fmt        - Format Nix files"
            echo "  nh                 - Fast NixOS rebuilds"
            echo "  nix-tree           - Explore dependency tree"
            echo "  nom                - Better nix build output"
            echo "  deploy-rs          - Remote NixOS deployments"
            echo "  nil                - Nix LSP for editors"
            echo ""
            echo "Environment variables:"
            echo "  NIXADDR: ''${NIXADDR:-not set}"
            echo "  NIXNAME: ''${NIXNAME:-dev-vm}"
            echo ""
            if command -v nh &> /dev/null; then
              echo "✅ nh (Nix helper) is available"
            fi
            echo ""
          '';
        };
      };

      flake =
        let
          system = "x86_64-linux";

          mkSystem = import ./lib/mkSystem.nix { inherit inputs; };
          dookuSystem = mkSystem {
            inherit system;
            machine = "dooku";
            user = "porebski";
            nixos-hardware = [
              nixos-hardware.nixosModules.lenovo-thinkpad
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-ssd
            ];
          };
          grievousSystem = mkSystem {
            inherit system;
            machine = "grievous";
            user = "przemek";
            nixos-hardware = [
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-gpu-nvidia
              nixos-hardware.nixosModules.common-pc-ssd
            ];
          };
          dathomirSystem = mkSystem {
            inherit system;
            machine = "dathomir";
            user = "przemek";
            nixos-hardware = nixos-hardware.nixosModules.dell-latitude-e7240;
          };
          ilumSystem = mkSystem {
            inherit system;
            machine = "ilum";
            user = "przemek";
          };
          devVmSystem = mkSystem {
            inherit system;
            machine = "dev-vm";
            user = "przemek";
            dev-vm = true;
            enableGhostty = true;
          };
          wslSystem = mkSystem {
            inherit system;
            machine = "wsl";
            user = "przemek";
            wsl = true;
          };

          backupExt = "backup_$(date +%Y%m%d_%H%M%S)";

          addBackup = homeConfig: homeConfig // { backupFileExtension = backupExt; };
        in
        {
          # nix run '.?submodules=1#homeConfigurations.<configuration>.activationPackage' --show-trace --impure -- switch
          # using `nh`
          # nh home switch --backup-extension backup_$(date +"%Y%M%H%M%S") '.?submodules=1' -- --show-trace --impure
          homeConfigurations = {
            ilum = addBackup ilumSystem.homeConfiguration.przemek;
            dathomir = addBackup dathomirSystem.homeConfiguration.przemek;
            dooku = addBackup dookuSystem.homeConfiguration.porebski;
            grievous = addBackup grievousSystem.homeConfiguration.przemek;
            dev-vm = addBackup devVmSystem.homeConfiguration.przemek;
            wsl = addBackup wslSystem.homeConfiguration.przemek;
          };

          # sudo nixos-rebuild switch --flake '.?submodules=1#<host_name>' --show-trace --impure
          # using nh
          # nh os switch --update '.?submodules=1' -- --impure --show-trace
          nixosConfigurations = {
            dathomir = dathomirSystem.nixosConfiguration.dathomir;
            dooku = dookuSystem.nixosConfiguration.dooku;
            grievous = grievousSystem.nixosConfiguration.grievous;
            ilum = ilumSystem.nixosConfiguration.ilum;
            dev-vm = devVmSystem.nixosConfiguration.dev-vm;
            wsl = wslSystem.nixosConfiguration.wsl;
          };

          deploy = {
            nodes = {
              dathomir = {
                hostname = "192.168.178.29";
                fastConnection = true;
                interactiveSudo = true;
                profiles.system = {
                  user = "root";
                  sshUser = "przemek";
                  path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.dathomir;
                };
              };
              dev-vm = {
                hostname = "dev-vm";
                fastConnection = false;
                interactiveSudo = true;
                profiles.system = {
                  user = "root";
                  sshUser = "przemek";
                  path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.dev-vm;
                };
              };
              dooku = {
                hostname = "dooku";
                fastConnection = true;
                interactiveSudo = true;
                profiles.system = {
                  user = "root";
                  sshUser = "porebski";
                  path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.dooku;
                };
              };
            };
          };
        };
    };
}
