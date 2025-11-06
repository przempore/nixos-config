{ inputs, ... }:
{ machine, system, nixos-hardware ? null, user, wsl ? false, dev-vm ? false, enableGhostty ? true }:
let
  isWSL = wsl;
  isDevVm = dev-vm;

  allowed-unfree-packages = [
    "netflix-via-google-chrome"
    "netflix-icon"
    "discord"
    "google-chrome"
    "spotify"
    "obsidian"
    "zoom"
    "libsciter"
  ];
  permittedInsecurePackages = [
    "nix-2.16.2"
    "electron-25.9.0"
    "electron-33.4.11"
    "mbedtls-2.28.10"
  ];

  # Import nixpkgs with unfree/insecure config for Home Manager evaluation as well
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) allowed-unfree-packages);
      permittedInsecurePackages = permittedInsecurePackages;
    };
  };

  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkg: builtins.elem (inputs.nixpkgs.lib.getName pkg) allowed-unfree-packages);
      permittedInsecurePackages = permittedInsecurePackages;
    };
  };

  legacyPkgs = inputs.legacy-nixpkgs.legacyPackages.${system};
  nixai = inputs.nixai;

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
  extraSpecialArgs = {
    inherit allowed-unfree-packages pkgs-unstable permittedInsecurePackages legacyPkgs machine nixai isWSL enableGhostty;
    catppuccin = inputs.catppuccin;
    zen-browser = inputs.zen-browser;
    tmux-sessionx = inputs.tmux-sessionx;
    neovim = inputs.neovim;
    nvim-config = inputs.nvim-config;
    home-manager-unstable = inputs.home-manager-unstable;
  } // (if enableGhostty then { ghostty = inputs.ghostty; } else { });
in
{
  homeConfiguration = {
    ${user} = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs extraSpecialArgs;
      modules = [
        # TODO: move modules around to unlock home configuration from machine
        ../hosts/${machine}/home
        (if !dev-vm && !isWSL then inputs.lix-module.nixosModules.default else { })
      ];
    };
  };

  nixosConfiguration = {
    ${machine} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable nixai; };
      modules = inputs.nixpkgs.lib.optional (nixos-hardware != null) nixos-hardware ++ [
        unfree-config
        ../hosts/${machine}/configuration.nix
        (if !dev-vm && !isWSL then inputs.lix-module.nixosModules.default else { })

        # sops-nix for secrets management (decrypted to /run/secrets)
        inputs.sops-nix.nixosModules.sops
        {
          sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        }

        (if isWSL then inputs.nixos-wsl.nixosModules.wsl else { })

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = ../hosts/${machine}/home;
          home-manager.extraSpecialArgs = extraSpecialArgs;
          home-manager.backupFileExtension = "backup-${inputs.self.rev or "dirty"}";
        }
      ];
    };
  };
}
