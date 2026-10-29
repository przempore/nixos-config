let
  workspaceNames = [ "1st" "2nd" "3rd" "4th" "5th" "6th" "7th" "8th" "9th" "10th" ];
  workspaceLabels = import ../home/desktop/workspace-labels.nix;
in
# Render declarations and every named keybinding with the same icon labels.
builtins.replaceStrings
  (map builtins.toJSON workspaceNames)
  (map builtins.toJSON workspaceLabels)
  (builtins.readFile ./config.kdl)
