{ pkgs, lib, config, ... }:
{
  imports = [ ./keyboard ];

  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = lib.mkDefault {
    enable = true;
    greeters.gtk.extraConfig = ''
      user-background = false
      [greeter]
      show-manual-login = true
      allow-guest = false
    '';
  };
  services.xserver.desktopManager.xfce.enable = lib.mkDefault true;
  services.xserver.windowManager.bspwm.enable = lib.mkDefault true;

  services.displayManager.sddm = lib.mkIf config.services.displayManager.sddm.enable {
    theme = "catppuccin-mocha-mauve";
    extraPackages = [ pkgs.catppuccin-sddm-corners ];
    package = pkgs.kdePackages.sddm;
  };

  services.xserver = {
    dpi = lib.mkDefault 90;
    autoRepeatDelay = 250;
    autoRepeatInterval = 25;
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "Hello";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy.AutoEnable = "true";
    };
  };

  services.printing.enable = true;
  services.pulseaudio = {
    enable = false;
    extraConfig = "
        load-module module-switch-on-connect
    ";
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    dejavu_fonts
    liberation_ttf
    source-code-pro
    siji
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    powerline-fonts
    powerline-symbols
    font-awesome
    line-awesome
    material-icons
    material-symbols
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
      font = "Noto Sans";
      fontSize = "9";
      loginBackground = true;
    })
    arandr
    autorandr
    xbacklight
    xmodmap
  ];
}
