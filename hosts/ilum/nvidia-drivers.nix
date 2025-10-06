{ config, pkgs, ... }:

{
  users.users.przemek.packages = with pkgs; [
    # used with closed nvidia drivers
    # libva
    # libva-utils
    # nvidia-vaapi-driver
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_6_16;
  # nixpkgs.config.nvidia.acceptLicense = true; # that's probably needed for non-free drivers

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    open = true;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/nvidia-x11/default.nix
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.64.05";
      sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
      openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
      settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
      persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
    };
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "570.124.04";
    #   sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q=";
    #   openSha256 = "sha256-KCGUyu/XtmgcBqJ8NLw/iXlaqB9/exg51KFx0Ta5ip0=";
    #   settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
    #   usePersistenced = false;
    # };
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "575.51.02";
    #   sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
    #   openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
    #   settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
    #   usePersistenced = false;
    # };
  };
}
