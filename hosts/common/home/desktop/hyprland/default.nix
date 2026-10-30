{ lib, machine, pkgs, ... }:
let
  hostLua = if machine == "ilum" || machine == "dooku" then machine else "default";
  workspaceLabels = import ../workspace-labels.nix;

  keyboardLayoutSwitch = pkgs.writeShellApplication {
    name = "hyprland-keyboard-layout-switch";
    runtimeInputs = [ pkgs.hyprland pkgs.jq ];
    text = builtins.readFile ./waybar/config/scripts/keyboard_layout_switch.sh;
  };

  hyprlandEnvironment = lib.optionalAttrs (machine == "ilum") {
    ".config/uwsm/env-hyprland".text = ''
      export NVD_BACKEND=direct
      export LIBVA_DRIVER_NAME=nvidia
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1
      export WLR_RENDERER=vulkan
    '';
  };
in
{
  imports = [
    ./dunst.nix
    ../noctalia.nix
  ];

  home.packages = [ keyboardLayoutSwitch ];

  programs.noctalia.settings.widget.keyboard_layout.actions.left =
    "exec ${keyboardLayoutSwitch}/bin/hyprland-keyboard-layout-switch";

  home.file = {
    # Declare leaf files so Home Manager links them into the existing config dir.
    ".config/hypr/lua/binds.lua".source = ./config/lua/binds.lua;
    ".config/hypr/lua/hosts/default.lua".source = ./config/lua/hosts/default.lua;
    ".config/hypr/lua/hosts/dooku.lua".source = ./config/lua/hosts/dooku.lua;
    ".config/hypr/lua/hosts/ilum.lua".source = ./config/lua/hosts/ilum.lua;
    ".config/hypr/lua/noctalia.lua".source = ./config/lua/noctalia.lua;
    ".config/hypr/lua/settings.lua".source = ./config/lua/settings.lua;
    ".config/hypr/lua/workspaces.lua".source = ./config/lua/workspaces.lua;
    ".config/hypr/lua/workspace_labels.lua".text = ''
      return {
        ${builtins.concatStringsSep "\n  " (map (label: "${builtins.toJSON label},") workspaceLabels)}
      }
    '';
    ".config/hypr/scripts/toggle_projector.sh".source = ./config/scripts/toggle_projector.sh;

    ".config/hypr/hyprland.lua".text = ''
      require("lua.settings")
      require("lua.hosts.${hostLua}")
      require("lua.binds")
      require("lua.noctalia")
    '';

    ".config/uwsm/env".text = ''
      export XCURSOR_THEME=catppuccin-mocha-dark-cursors
      export XCURSOR_SIZE=24
    '';
  } // hyprlandEnvironment;
}
