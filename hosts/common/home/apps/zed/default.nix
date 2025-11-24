{ pkgs-unstable
, ...
}: {
  home = {
    packages = [
      pkgs-unstable.zed-editor-fhs
      # pkgs-unstable.zed-editor.remote_server
    ];

    file.".config/zed/settings.json".source = ./settings.json;
    file.".config/zed/keymap.json".source = ./keymap.json;
  };
}
