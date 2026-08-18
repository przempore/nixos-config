{ config, pkgs, ... }:

{
  users.users.przemek.packages = with pkgs; [
    # used with closed nvidia drivers
    # libva
    # libva-utils
    # nvidia-vaapi-driver
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  # Ensure NVIDIA kernel module owns the GPU, not Nova/nouveau.
  boot.blacklistedKernelModules = [ "nova_core" "nova" "nouveau" "nvidiafb" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # boot.kernelPackages = pkgs.linuxPackages_6_18;
  # nixpkgs.config.nvidia.acceptLicense = true; # that's probably needed for non-free drivers

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    open = true;
    # 595.71.05 does not build against Linux 7.2 (it calls strncpy without
    # including its header).  595.91.07 contains NVIDIA's strscpy fix.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.91.07";
      sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
      sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
      openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
      settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
      persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
    };
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # https://github.com/NixOS/nixpkgs/issues/467145#issuecomment-3603995380
    # package = config.boot.kernelPackages.nvidiaPackages.stable // {
    #   open = config.boot.kernelPackages.nvidiaPackages.stable.open.overrideAttrs (old: {
    #     patches = (old.patches or [ ]) ++ [
    #       (pkgs.fetchpatch {
    #         name = "get_dev_pagemap.patch";
    #         url = "https://github.com/NVIDIA/open-gpu-kernel-modules/commit/3e230516034d29e84ca023fe95e284af5cd5a065.patch";
    #         hash = "sha256-BhL4mtuY5W+eLofwhHVnZnVf0msDj7XBxskZi8e6/k8=";
    #       })
    #     ];
    #   });
    # };
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "575.64.05";
    #   sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
    #   openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
    #   settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
    #   persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
    # };
    # package =
    # let
    #     base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #         version = "590.48.01";
    #         sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
    #         openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
    #         settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
    #         persistencedSha256 = "";
    #     };
    #     cachyos-nvidia-patch = pkgs.fetchpatch {
    #         url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
    #         sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
    #     };
    #
    #     # Patch the appropriate driver based on config.hardware.nvidia.open
    #     driverAttr = if config.hardware.nvidia.open then "open" else "bin";
    # in
    # base
    # // {
    #     ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
    #         patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
    #     });
    # };
  };
}
