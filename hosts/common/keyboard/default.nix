{ ... }:
{
  services.xserver.xkb = {
    layout = "real-prog-dvorak";
    extraLayouts.real-prog-dvorak = {
      description = "Real proogrammer dvorak";
      languages = [ "pl" ];
      symbolsFile = ./symbols/real-prog-dvorak.xkb;
    };
  };

  console.useXkbConfig = true;
}
