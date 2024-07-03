{ ... }:
{
  programs = {
    starship =
    {
      enable = true;
      # custom settings
      enableFishIntegration = true;
      enableZshIntegration = true;
      settings = {
        format = "$all"; # Remove this line to disable the default prompt format
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = false;
        custom.qt-fhs-env = {
          command = "echo $QT_ENV";
          when = "test -n \"$QT_ENV\"";
          symbol = " ";
          style = "bold red";
          format = "[$symbol($output)]($style) ";
        };
      };
    };
  };
}
