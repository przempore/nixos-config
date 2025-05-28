{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    yt-dlp
  ];

  programs.firefox = {
    enable = true;
    profiles.przemek = {
      isDefault = true;
      userChrome = ''
        @import "${
            builtins.fetchGit {
                url = "https://github.com/rockofox/firefox-minima";
                ref = "main";
                rev = "dc40a861b24b378982c265a7769e3228ffccd45a";
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
        "sidebar.verticalTabs" = true;
      };
      search = {
        force = true;
        default = "ddg";
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "Home Manager - Options Search" = {
            urls = [{
              template = "https://home-manager-options.extranix.com/";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@hm" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "bing".metaData.hidden = true;
          "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };
    };
  };
}
