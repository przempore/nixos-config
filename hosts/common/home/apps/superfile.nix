{ ... }:
{
  home.file.".config/superfile/hotkeys.toml".source = "${builtins.fetchGit {
    url = "https://github.com/yorukot/superfile";
    ref = "main";
    rev = "624edd93667e8cfc4d528aea23413f311611d9a3";
  }}/src/superfile_config/vimHotkeys.toml";
}
