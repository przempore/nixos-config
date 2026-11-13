{ config, lib, pkgs, pkgs-unstable, ... }:
let
  hansard = pkgs-unstable.callPackage ./package.nix { };
  setup = pkgs.writeShellScript "hansard-setup" ''
    set -eu

    # Initialize only a new archive; retain settings changed in Hansard's UI.
    if [ ! -f "$HOME/.hansard/config.json" ]; then
      ${lib.getExe hansard} init --yes --storage local \
        --sources codex-cli --watch-sources codex-cli --skip-import \
        --no-autostart --no-track-usage --no-agent-collaboration \
        --no-recall --no-telemetry
      ${lib.getExe hansard} config set imports.autoDiscoverSources false
      ${lib.getExe hansard} config set integrations.autoInstall false
    fi

    # Nix manages upgrades and login startup. Refresh recall after upgrades,
    # preserving the rest of Codex's writable config and existing skill files.
    ${lib.getExe hansard} config set updates.checkOnStartup false
    ${lib.getExe hansard} integrations add-to codex
  '';
in
{
  home.packages = [ hansard ];

  # Codex ACP in Emacs uses the same ~/.codex/config.toml and session store
  # as the CLI. Its MCP entry uses the installed Node/Hansard store paths.
  systemd.user.services.hansard = {
    Unit.Description = "Hansard background archive for Codex";
    Service = {
      ExecStartPre = "${setup}";
      ExecStart = "${lib.getExe hansard} watcher start --foreground";
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.git pkgs.ripgrep pkgs.zstd pkgs.coreutils pkgs.systemd ]}:${config.home.profileDirectory}/bin:/run/current-system/sw/bin"
        "HANSARD_NO_UPDATE_CHECK=1"
        "HANSARD_NO_WHATS_NEW=1"
      ];
      Restart = "on-failure";
      RestartSec = 10;
      TimeoutStartSec = 120;
      TimeoutStopSec = 60;
      UMask = "0077";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
