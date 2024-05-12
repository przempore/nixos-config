{ pkgs
, pkgs-unstable
, config
, ...
}: {
  nixpkgs.overlays =
    let
      # Change this to a rev sha to pin
      moz-rev = "master";
      moz-url = builtins.fetchTarball { url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz"; };
      nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
    in
    [
      nightlyOverlay
    ];

  home.packages = with pkgs; [
    youtube-dl
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin;
    profiles.przemek = {
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
      search = {
        default = "DuckDuckGo";
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
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };
    };
  };
}
