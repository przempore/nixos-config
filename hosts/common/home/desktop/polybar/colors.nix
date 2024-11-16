{ ... }: {
  services.polybar.config = {
    # "colors" = builtins.readFile (catppuccin-polybar + "/themes/mocha.ini");
    "colors" = {
      background = "#0a0f14";
      foreground = "#99d1ce";
      alert = "#d26937";
      volume-min = "#2aa889";
      volume-med = "#edb443";
      volume-max = "#c23127";
    };
  };
}
