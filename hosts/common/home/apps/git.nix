{ lib, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    aliases = {
      lg = "log --graph --pretty=format:'%C(auto)%h -%d %s"
        + " %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      st = "status -sb";
    };

    attributes = [
      "* text=auto"
    ];

    userEmail = lib.mkDefault "przempore@gmail.com";
    userName = lib.mkDefault "Przemek";

    ignores = [ ".envrc" ".direnv/" ];
    extraConfig = lib.mkDefault {
      push.default = "current";

      init.defaultBranch = "main";
      submodule.recurse = "true";
      pull.rebase = "true";
      rebase.autosquash = "true";
      rerere.enabled = true;
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };
}
