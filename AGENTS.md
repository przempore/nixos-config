# AGENTS.md

This repo does not currently include agent instructions. This file defines the
default expectations for AI coding agents working in this workspace.

## Scope
- Read and follow this file for all tasks in this repo.
- Do not assume external context beyond the repository unless explicitly given.

## Workflow
- Prefer ripgrep (`rg`) for searching files and text.
- Keep changes minimal and focused; avoid unrelated refactors.
- Use `apply_patch` for small, single-file edits when possible.
- Preserve existing style and conventions in Nix files.
- Default to POSIX `sh`/`bash` syntax for command examples; if fish-specific behavior matters (e.g. exit status), remember fish uses `$status` rather than `$?`.
- When changing niri configs/scripts:
  - Validate KDL with `niri validate -c <path>` when practical.
  - Inspect `niri msg -j outputs` output shape (it may be an object keyed by output name or an array).

## Safety
- Do not delete or revert unrelated changes without explicit request.
- Avoid destructive git commands unless explicitly asked.
- Ask before running commands that require network access or escalation.

## Communication
- Be concise; summarize what changed and why.
- Point to exact file paths for edits.
- Suggest next steps only when useful (e.g., `nixos-rebuild`, tests).

## Maintenance follow-ups
- When updating `nixpkgs-unstable` or working on OpenCode, review the temporary
  dependency hash override in `lib/mkSystem.nix` (added 2026-11-04 for OpenCode
  2.2.5). The guarded version and original hash identify the affected recipe.
- If the upstream recipe no longer matches that guard, remove the obsolete
  override and this follow-up after validating Nix evaluation and, when practical,
  an OpenCode build without the override. If the guard still matches, keep the
  workaround unless a successful unmodified build proves it is unnecessary.
- On the next nixpkgs update, review `nixpkgs-codex` in `flake.nix`, pinned to
  `f9a75f41be3a74eab55d3a7679d34ad6cc0da977` for Codex 0.166.0 and codex-acp
  2.1.1. Codex 0.167.0 failed because its recipe requested system AWS-LC but
  discovered OpenSSL instead. Test both packages from the updated unstable input;
  if they build successfully, remove the dedicated input and lock entry, switch
  the common Home Manager packages back to `pkgs-unstable`, and remove this note.
- On the next nixpkgs update, review `nixpkgs-emacs` in `flake.nix`, pinned to
  `f9a75f41be3a74eab55d3a7679d34ad6cc0da977` for Emacs 31.1 and Ghostel /
  evil-ghostel 0.59.0. Newer recipes failed fetching Ghostel's Zig dependencies
  with `TlsInitializationFailed`; the pin reuses the installed working outputs.
  Test the updated unstable Emacs/Ghostel package set, including a fresh Zig
  dependency fetch (cached outputs alone do not prove it is fixed), and load the
  native module in Emacs. Once those pass, remove the dedicated input and lock
  entry, restore `pkgs-unstable` in `hosts/common/home/apps/emacs/default.nix`,
  and remove this note. Keep this pin independent of the Codex pin.
