{ ... }:
{
  home.file.".config/superfile/hotkeys.toml".source = "${builtins.fetchGit {
    url = "https://github.com/yorukot/superfile";
    ref = "main";
    rev = "af760879998e16aee0ddbdafa396374114614558";
  }}/src/superfile_config/vimHotkeys.toml";
}
