{ pkgs, ... }: {
  home.packages = with pkgs; [
    ansible
    ansible-lint
    yamllint
    ansible-language-server
  ];
}
