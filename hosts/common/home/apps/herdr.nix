{ pkgs-unstable
, ...
}: {
  home.packages = with pkgs-unstable; [
    herdr
  ];

  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [ui.sound]
    enabled = false

    [ui]
    agent_panel_sort = "spaces"
    show_agent_labels_on_pane_borders = true
    hide_tab_bar_when_single_tab = true
    sidebar_collapsed_mode = "hidden"
    prompt_new_tab_name = false

    [experimental]
    pane_history = true

    [keys]
    prefix = "ctrl+a"
    switch_tab = ""

    next_workspace = "prefix+)"
    previous_workspace = "prefix+("

    # Zero-based tab shortcuts implemented with Herdr's tab API.
    [[keys.command]]
    key = "prefix+0"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[0].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+1"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[1].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+2"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[2].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+3"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[3].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+4"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[4].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+5"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[5].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+6"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[6].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+7"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[7].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+8"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[8].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'

    [[keys.command]]
    key = "prefix+9"
    type = "shell"
    command = 'tab_id="$(herdr tab list --workspace "$HERDR_ACTIVE_WORKSPACE_ID" | jq -r ".result.tabs | sort_by(.number) | .[9].tab_id // empty")" && [ -n "$tab_id" ] && herdr tab focus "$tab_id"'
  '';

}
