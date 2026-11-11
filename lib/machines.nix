{ nixos-hardware }:

{
  aquarium-monitor = {
    user = "przemek";
    hardwareModules = nixos-hardware.nixosModules.dell-latitude-e7240;
    enableGhostty = false;
    enableGui = false;
    deployments = {
      aquarium-monitor = {
        hostname = "100.78.207.28";
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
      # Reuse the P15v Gen 3 Intel support without its NVIDIA-specific imports.
      "${nixos-hardware}/lenovo/thinkpad/p15v"
      "${nixos-hardware}/common/cpu/intel/alder-lake"
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
}
