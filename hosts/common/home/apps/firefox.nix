{ pkgs
, pkgs-unstable
, config
, ...
}: {
  home.packages = with pkgs; [
    youtube-dl
  ];

  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox-devedition-unwrapped;
    profiles.default = {
      isDefault = true;
      userChrome = ''
        @import "${
            builtins.fetchGit {
                url = "https://github.com/rockofox/firefox-minima";
                ref = "main";
                rev = "c5580fd04e9b198320f79d441c78a641517d7af5";
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
