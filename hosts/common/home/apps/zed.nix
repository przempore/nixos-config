{
  pkgs-unstable,
  pkgs,
  lib,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    extensions = [
      "nix"
      "toml"
      "make"
      "opencode"
    ];

    userSettings = {
      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      hour_format = "hour24";
      auto_update = false;

      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "right";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
        };
        font_family = "FiraCode Nerd Font";
        font_features = null;
        font_size = null;
        line_height = "comfortable";
        option_as_meta = false;
        button = false;
        shell = "system";
        toolbar = {
          title = true;
        };
        working_directory = "current_project_directory";
      };

      agent = {
        dock = "right";
        sidebar_side = "right";
        default_model = {
          provider = "zed.dev";
          model = "gpt-5.5";
        };
        default_open_ai_model = null;
        enabled = true;
      };

      lsp = {
        nixd = {
          binary = {
            path = lib.getExe pkgs.nixd;
          };
        };
        nil = {
          binary = {
            path = lib.getExe pkgs.nil;
          };
        };
      };

      languages = {

      };

      vim_mode = true;
      relative_line_numbers = "enabled";
      vim = {
        use_system_clipboard = "never";
        toggle_relative_line_numbers = true;
      };

      # load_direnv = "shell_hook";
      load_direnv = "disabled";
      base_keymap = "SublimeText";

      theme = {
        mode = "system";
      };

      show_whitespaces = "all";
      ui_font_size = 15;
      buffer_font_size = 13;
    };
    userKeymaps = [
      {
        context = "Terminal";
        bindings = {
          "ctrl-p" = [
            "terminal::SendKeystroke"
            "ctrl-p"
          ];
          "ctrl-n" = [
            "terminal::SendKeystroke"
            "ctrl-n"
          ];
          "ctrl-a" = [
            "terminal::SendKeystroke"
            "ctrl-a"
          ];
          "ctrl-e" = [
            "terminal::SendKeystroke"
            "ctrl-e"
          ];
          "ctrl-b" = [
            "terminal::SendKeystroke"
            "ctrl-b"
          ];
          "ctrl-f" = [
            "terminal::SendKeystroke"
            "ctrl-f"
          ];
          "alt-b" = [
            "terminal::SendKeystroke"
            "alt-b"
          ];
          "alt-f" = [
            "terminal::SendKeystroke"
            "alt-f"
          ];
        };
      }
      {
        context = "Workspace";
        bindings = {
          "ctrl-shift-t" = "terminal_panel::Toggle";
        };
      }
      {
        context = "Editor && mode == full && vim_mode == visual";
        bindings = {
          "shift-j" = "editor::MoveLineDown";
          "shift-k" = "editor::MoveLineUp";
          "space p" = [
            "workspace::SendKeystrokes"
            "\"_dP"
          ];
          "space d" = [
            "workspace::SendKeystrokes"
            "\"_d"
          ];
          "space y" = "editor::Copy";
        };
      }
      {
        context = "Editor && mode == full && vim_mode == normal";
        bindings = {
          "space o v" = "pane::RevealInProjectPanel";
          "space g b" = "git::Branch";
          "space g a" = "editor::ToggleCodeActions";
          "space g r" = "editor::FindAllReferences";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          "ctrl-y" = "editor::ConfirmCompletion";
        };
      }
      {
        context = "VimControl && !menu";
        bindings = {
          "space w s" = "project_symbols::Toggle";
        };
      }
      {
        bindings = {
          f10 = "editor::SwitchSourceHeader";
        };
      }
    ];
  };
}
