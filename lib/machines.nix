{ nixos-hardware }:

{
  aquarium-monitor = {
    user = "przemek";
    hardwareModules = nixos-hardware.nixosModules.dell-latitude-e7240;
    enableGhostty = false;
    enableGui = false;
    deployments = {
      aquarium-monitor = {
        hostname = "192.168.178.29";
        sshUser = "przemek";
        fastConnection = true;
      };
    };
  };

  dathomir = {
    user = "przemek";
  };

  dev-vm = {
    user = "przemek";
    enableGhostty = false;
    deployments = {
      dev-vm = {
        hostname = "dev-vm";
        sshUser = "przemek";
      };
    };
  };

  dooku = {
    user = "porebski";
    hardwareModules = [
      nixos-hardware.nixosModules.lenovo-thinkpad
      nixos-hardware.nixosModules.common-cpu-intel
      nixos-hardware.nixosModules.common-pc-ssd
    ];
    deployments = {
      dooku = {
        hostname = "dooku";
        sshUser = "porebski";
      };
      dooku_local = {
        hostname = "dooku_local";
        sshUser = "porebski";
        fastConnection = true;
      };
    };
  };

  ilum = {
    user = "przemek";
  };

  wsl = {
    user = "przemek";
    isWSL = true;
    enableGhostty = false;
  };
}
