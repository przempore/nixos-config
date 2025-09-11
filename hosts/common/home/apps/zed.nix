{ pkgs-unstable
, ...
}: {
  home = {
    packages = [
      pkgs-unstable.zed-editor
    ];
    file.".config/zed/settings.json".text = ''
// Zed settings
//
// For information on how to configure Zed, see the Zed
// documentation: https://zed.dev/docs/configuring-zed
//
// To see all of Zed's default settings without changing your
// custom settings, run `zed: open default settings` from the
// command palette (cmd-shift-p / ctrl-shift-p)
{
  "minimap": {
    "show": "never"
  },
  "inlay_hints": {
    "enabled": false,
    "show_value_hints": true,
    "show_type_hints": true,
    "show_parameter_hints": true,
    "show_other_hints": true,
    "show_background": false,
    "edit_debounce_ms": 700,
    "scroll_debounce_ms": 50,
    "toggle_on_modifiers_press": {
      "control": false,
      "alt": false,
      "shift": false,
      "platform": false,
      "function": false
    }
  },
  "telemetry": {
    "diagnostics": true,
    "metrics": true
  },
  "vim_mode": true,
  "icon_theme": {
    "mode": "dark",
    "light": "Zed (Default)",
    "dark": "Zed (Default)"
  },
  "base_keymap": "SublimeText",
  "ui_font_size": 16.0,
  "buffer_font_size": 15.0,
  "theme": {
    "mode": "dark",
    "light": "One Light",
    "dark": "One Dark"
  }
}
    '';
    file.".config/zed/keymap.json".text = ''
// Zed keymap
//
// For information on binding keys, see the Zed
// documentation: https://zed.dev/docs/key-bindings
//
// To see the default key bindings run `zed: open default keymap`
// from the command palette.
[
  {
    "context": "Workspace",
    "bindings": {
      // "shift shift": "file_finder::Toggle"
    }
  },
  {
    "context": "Editor && vim_mode == insert",
    "bindings": {
      // "j k": "vim::NormalBefore"
    }
  },
  {
    "context": "Editor && showing_completions",
    "bindings": {
      "ctrl-y": "editor::ConfirmCompletion"
    }
  },
]

      '';
  };
}
