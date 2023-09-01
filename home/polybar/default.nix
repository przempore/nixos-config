{ pkgs, ... }:
{
  imports = [
    ./colors.nix
  ];
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override { alsaSupport = true; };
    script = ''
      polybar --reload mainbar &
    '';

    config = {
      "settings" = {
# include-file = builtins.readFile
#   (catppuccin-polybar + "/themes/mocha.ini");
        margin-top = 0;
        margin-bottom = 0;

        throttle-output = 5;
        throttle-output-for = 10;
        screenchange-reload = "true";
        compositing-background = "over";
        compositing-foreground = "over";
        compositing-overline = "over";
        compositing-underline = "over";
        compositing-border = "over";
      };
      "bar/mainbar" = {
        monitor = "Virtual-1";
        width = "100%";
        height = 30;
        radius = "0.0";
        fixed-center = true;
        bottom = false;
        separator = "|";

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = 2;
        line-color = "#f00";

        wm-restack = "bspwm";
        override-redirect = true;

        enable-ipc = true;

        border-size = 0;
        border-color = "#00000000";

        padding-left = 0;
        padding-right = 1;

        module-margin-left = 3;
        module-margin-right = 3;

        font-0 = "JetBrains Mono Nerd:size=10;0";
        font-1 = "JetBrains Mono Nerd:size=13;0";
        font-2 = "JetBrains Mono Nerd:size=10;0";
        font-3 = "JetBrains Mono Nerd:size=10;0";

        modules-left = "bspwm xwindow";
        # modules-center = kernel temperature2;
        modules-right = "pavolume memory2 cpu2"; #xkeyboard date";

        tray-detached = false;
        tray-offset-x = 0;
        tray-offset-y = 0;
        tray-padding = 2;
        tray-maxsize = 20;
        tray-scale = "1.0";
        tray-position = "right";
        tray-background = "\${colors.background}";

        scroll-up = "bspwm-desknext";
        scroll-down = "bspwm-deskprev";

      };
      "module/bspwm" = {
        type = "internal/bspwm";

        enable-click = true;
        enable-scroll = true;
        reverse-scroll = true;
        pin-workspaces = true;

        ws-icon-0 = "1;";
        ws-icon-1 = "2;";
        ws-icon-2 = "3;";
        ws-icon-3 = "4;";
        ws-icon-4 = "5;";
        ws-icon-5 = "6;";
        ws-icon-6 = "7;";
        ws-icon-7 = "8;";
        ws-icon-8 = "9;";
        ws-icon-9 = "10;";
        ws-icon-default = " ";


        format = "<label-state> <label-mode>";

        label-focused = "%icon%";
        label-focused-background = "\${colors.background}";
        label-focused-underline= "#6790eb";
        label-focused-padding = 4;
        label-focused-foreground = "#6790EB";

        label-occupied = "%icon%";
        label-occupied-padding = 2;
        label-occupied-background = "\${colors.background}";
        label-occupied-foreground = "#6790EB";

        label-urgent = "%icon%";
        label-urgent-padding = 2;

        label-empty = "%icon%";
        label-empty-foreground = "\${colors.foreground}";
        label-empty-padding = 2;
        label-empty-background = "\${colors.background}";
        label-monocle = "  ";
        label-monocle-foreground = "\${colors.foreground}";
        label-tiled = "  ";
        label-tiled-foreground = "\${colors.foreground}";
        label-fullscreen = "  ";
        label-fullscreen-foreground = "\${colors.foreground}";
        label-floating = "  ";
        label-floating-foreground = "\${colors.foreground}";
        label-pseudotiled = "  ";
        label-pseudotiled-foreground = "\${colors.foreground}";
        label-locked = "  ";
        label-locked-foreground = "\${colors.foreground}";
        label-sticky = "  ";
        label-sticky-foreground = "\${colors.foreground}";
        label-private =  "     ";
        label-private-foreground = "\${colors.foreground}";

        format-foreground = "\${colors.foreground}";
        format-background = "\${colors.background}";
      };

      "module/xwindow" = {
        type = "internal/xwindow";

        label = "%title%";
        label-maxlen = 50;

        format-foreground = "\${colors.foreground}";
        format-background = "\${colors.background}";
      };

      "module/memory2" = {
        type = "internal/memory";
        interval = 1;
        label = "%percentage_used%%";

        format = "Mem <label>";
        format-prefix = "  ";
        format-prefix-foreground = "#3384d0";
        format-underline = "#3384d0";
        format-foreground = "\${colors.foreground}";
        format-background = "\${colors.background}";
      };

     "module/cpu2" = {
       type = "internal/cpu";
       interval = 1;
       format-foreground = "\${colors.foreground}";
       format-background = "\${colors.background}";
       format-prefix = "  ";
       format-prefix-foreground = "#cd1f3f";
       format-underline = "#cd1f3f";

       label-font = 3;

       format = "<label>";

       format-padding = 2;

       label = "Cpu %percentage:3%%";
     };

    };
  };
}
