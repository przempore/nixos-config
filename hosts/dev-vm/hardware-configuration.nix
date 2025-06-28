# Universal VM Hardware Configuration
# Works with QEMU/KVM, VirtualBox, Hyper-V, VMware, etc.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  # Universal VM kernel modules that work across hypervisors
  boot.initrd.availableKernelModules = [
    # SATA/IDE support (VirtualBox)
    "ahci"
    "ata_piix"
    "sd_mod"
    "sr_mod"
    # USB support
    "xhci_pci"
    "ehci_pci"
    "uhci_hcd"
    # VirtIO support (QEMU/KVM)
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "virtio_net"
    # Hyper-V support
    "hv_vmbus"
    "hv_storvsc"
    "hv_netvsc"
  ];

  boot.initrd.kernelModules = [ ];

  # Support both Intel and AMD virtualization
  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Generic VM filesystem layout using device paths
  # More reliable than UUIDs across different VM platforms
  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];

  # Network configuration that works across hypervisors
  networking.useDHCP = lib.mkDefault true;

  # Universal virtualization settings
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable guest services for better integration
  virtualisation.hypervGuest.enable = lib.mkDefault true;

  # VirtualBox guest additions (disabled by default - enable manually if using VirtualBox)
  # virtualisation.virtualbox.guest.enable = lib.mkDefault false;
}
