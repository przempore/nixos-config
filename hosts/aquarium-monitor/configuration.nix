# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../common/base.nix
      ../common/keyboard
      ./hardware-configuration.nix
      inputs.aquarium-monitor.nixosModules.default
      inputs.orgbrain.nixosModules.default
    ];

  system.autoUpgrade.enable = true;
  # Scheduled rebuilds must use this deployed flake, not the old /etc/nixos bootstrap.
  system.autoUpgrade.flake = "${inputs.self.outPath}#aquarium-monitor";
  system.autoUpgrade.operation = "boot";
  system.autoUpgrade.dates = "weekly";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "aquarium-monitor"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.tailscale = {
    enable = true;
    package = pkgs-unstable.tailscale;
  };

  sops.secrets."aquarium-monitor/influxdb-init" = {
    sopsFile = ../../secrets/aquarium-monitor.yaml;
    key = "aquarium_monitor_influxdb_init";
  };

  sops.secrets."aquarium-monitor/influxdb-token" = {
    sopsFile = ../../secrets/aquarium-monitor.yaml;
    key = "aquarium_monitor_influxdb_token";
  };

  sops.secrets."aquarium-monitor/grafana-environment" = {
    sopsFile = ../../secrets/aquarium-monitor.yaml;
    key = "aquarium_monitor_grafana_environment";
  };

  services.aquarium-monitor = {
    simulator = {
      enable = true;
      tankId = "demo-tank";
      temperatureC = 26.5;
      intervalSeconds = 1;
    };

    influxdb = {
      enable = true;
      healthCheck.enable = false;
      organization = "aquarium";
      bucket = "telemetry";
      retention = "30d";
      environmentFile = config.sops.secrets."aquarium-monitor/influxdb-init".path;
      tokenFile = config.sops.secrets."aquarium-monitor/influxdb-token".path;
    };

    influxBatchSize = 10;
    influxAlarmOutput = true;
    alarmOutput = "stderr";

    # Demonstration limits; replace after real sensor calibration.
    temperatureMinimum = 20.0;
    temperatureMaximum = 30.0;
    temperatureSeverity = "warning";

    grafana = {
      enable = true;
      healthCheck.enable = false;
      listenAddress = "100.78.207.28";
      provisioning = {
        enable = true;
        tokenEnvironmentFile = config.sops.secrets."aquarium-monitor/grafana-environment".path;
      };
      dashboard.enable = true;
    };
  };

  services.orgbrain = {
    enable = true;
    package = inputs.orgbrain.packages.x86_64-linux.default;
    owner = "przempore@gmail.com";
    publicUrl = "https://aquarium-monitor.tailb9a1a1.ts.net:8443";
    port = 8787;
    repository = "/var/lib/orgbrain/repository";
    orgSubdirectory = "org";
    branch = "main";
    settings = {
      inbox = "inbox.org";
      # Calendar credentials can be added separately through runtime files.
    };
  };

  # Add one HTTPS listener without resetting other Tailscale Serve routes.
  # Grafana remains available at the existing Tailscale address on port 3000.
  systemd.services.orgbrain-tailscale-serve = {
    description = "Expose OrgBrain privately over Tailscale HTTPS";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    requires = [ "tailscaled.service" "orgbrain.service" ];
    after = [ "network-online.target" "tailscaled.service" "orgbrain.service" ];
    path = [ config.services.tailscale.package ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 15;
      TimeoutStartSec = 60;
    };
    script = ''
      tailscale serve --bg --yes --https=8443 http://127.0.0.1:8787
    '';
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3000 8443 ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.przemek = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    curl
    wget
    iw
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
