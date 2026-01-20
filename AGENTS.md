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
