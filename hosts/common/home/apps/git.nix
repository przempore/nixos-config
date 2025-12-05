{ lib, ... }: {
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        side-by-side = true;
      };
    };
    git = {
      enable = true;
      lfs.enable = true;

      settings = {
        user = {
          name = lib.mkDefault "Przemek";
          email = lib.mkDefault "przempore@gmail.com";
        };

        alias = {
          lg = "log --graph --pretty=format:'%C(auto)%h -%d %s"
            + " %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
          st = "status -sb";
        };

        push.default = "current";

        init.defaultBranch = "main";
        submodule.recurse = "true";
        pull.rebase = "true";
        rebase.autosquash = "true";
        rerere.enabled = true;
      };

      attributes = [
        "* text=auto"
      ];

      ignores = [ ".envrc" ".direnv/" ];
    };
  };
}
