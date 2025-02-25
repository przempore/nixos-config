{ pkgs-unstable
, ...
}: {
  home = {
    packages = [
      pkgs-unstable.zed-editor
    ];
    file.".config/zed/settings.json".text = ''
      {
      "ui_font_size": 16,
      "buffer_font_size": 16,
      "theme": {
          "mode": "dark",
          "light": "One Light",
          "dark": "One Dark"
      },
      "vim_mode": true,
      "base_keymap": "SublimeText"
      }
    '';
  };
}
