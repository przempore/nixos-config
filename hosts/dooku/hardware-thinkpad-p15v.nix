{ lib, ... }:
{
  # P15v-specific tweaks not covered by nixos-hardware yet.
  boot.kernelParams = lib.mkDefault [ "acpi_backlight=native" ];
  services.fprintd.enable = lib.mkDefault true;
}
