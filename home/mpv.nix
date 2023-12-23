{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    mpv
  ];

  home.file.".config/mpv/mpv.conf".text = ''
    ytdl-format=bestvideo[height<=?1080]+bestaudio/best
    --save-position-on-quit
  '';

}
