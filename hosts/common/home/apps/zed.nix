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
      # "rust"
      "make"
      "opencode"
    ];
    userSettings = {
      assistant = {
        enabled = true;
        version = "2";
        default_open_ai_model = null;

        default_model = {
          provider = "zed.dev";
          model = "gpt-5.3-codex";
        };

      };

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

      lsp = {
        rust-analyzer = {
          binary = {
            path = lib.getExe (
              pkgs.writeShellApplication {
                name = "zed-rust-analyzer";
                runtimeInputs = [
                  pkgs.direnv
                ];
                text = ''
                  if direnv exec "$PWD" sh -lc 'command -v rust-analyzer >/dev/null'; then
                    exec direnv exec "$PWD" rust-analyzer "$@"
                  fi

                  exec ${lib.getExe pkgs.rust-analyzer} "$@"
                '';
              }
            );
          };
        };
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
        # light = "One Light";
        # dark = "Catppuccin Macchiato";
      };

      show_whitespaces = "all";
      ui_font_size = 15;
      buffer_font_size = 13;
    };
    userKeymaps = [
      {
        context = "Workspace";
        bindings = {
        };
      }
      {
        context = "Editor && vim_mode == insert";
        bindings = {
        };
      }
      {
        context = "Editor && vim_mode == normal";
        bindings = {
          "space o v" = "pane::RevealInProjectPanel";
          "space g b" = "git::Branch";
          "space g a" = "editor::ToggleCodeActions";
        };
      }
      {
        context = "Editor";
        bindings = {
          "ctrl-y" = "editor::ConfirmCompletion";
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
