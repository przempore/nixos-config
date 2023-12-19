{ pkgs
, config
, ...
}: {
  home.packages = with pkgs; [
    firefox
    youtube-dl
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      userChrome = ''
        @import "${
            builtins.fetchGit {
                url = "https://github.com/rockofox/firefox-minima";
                ref = "main";
                rev = "932a99851b5f2db8b58aa456e5d897e278c69574";
            }
          }/userChrome.css";
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.ctrlTab.recentlyUsedOrder" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "datareporting.policy.dataSubmissionEnable" = false;
        "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
    };
  };
}
