{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    aliases = {
      lg = "log --graph --pretty=format:'%C(auto)%h -%d %s"
        + " %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      st = "status -sb";
    };

    userEmail = "przempore@gmail.com";
    userName = "Przemek";

    ignores = [ ".envrc" ".direnv/" ];
    extraConfig = {
      push.default = "current";

      init.defaultBranch = "main";
      submodule.recurse = "true";
      pull.rebase = "true";
      rebase.autosquash = "true";
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };
}
