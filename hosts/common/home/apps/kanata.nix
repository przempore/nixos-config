{ pkgs, lib, config, ... }: {
  services.kanata = {
    enable = true;
    keyboards = {
      "default" = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            caps
          )
          (deflayer base
            @cec
          )

          (deflayer nomods
            esc
          )
          (deffakekeys
            to-base (layer-switch base)
          )
          (defalias
            cec (tap-hold 200 200 esc lctl)
          )
        '';
      };
    };
  };
}
