-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.set_environment_variables = {
  IS_WEZTERM = "true"
}

config.audible_bell = "Disabled"

-- For example, changing the color scheme:
-- config.color_scheme = 'Batman'

config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.95

config.font_size = 9.5
config.font =
  wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Medium' })
  -- wezterm.font('Iosevka Nerd Font Mono', { weight = 'Medium' })


-- config.font = wezterm.font_with_fallback {
--   'JetBrainsMono Nerd Font Mono',
--   'JetBrainsMono Nerd Font',
--   'Iosevka Nerd Font Mono',
--   'Iosevka Nerd Font Mono',
--   'nonicons',
-- }

wezterm.on('window-resized', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local is_fullscreen = window:get_dimensions().is_full_screen
  set_background(overrides, is_fullscreen)
  window:set_config_overrides(overrides)
end)

wezterm.on('update-status', function(window, pane)
  local cells = {}

  -- Figure out the hostname of the pane on a best-effort basis
  local hostname = wezterm.hostname()
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri and cwd_uri.host then
    hostname = cwd_uri.host
  end
  table.insert(cells, ' ' .. hostname)

  -- Format date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime ' %a %b %-d %H:%M'
  table.insert(cells, date)

  -- Add an entry for each battery (typically 0 or 1)
  local batt_icons = {'', '', '', '', ''}
  for _, b in ipairs(wezterm.battery_info()) do
    local curr_batt_icon = batt_icons[math.ceil(b.state_of_charge * #batt_icons)]
    table.insert(cells, string.format('%s %.0f%%', curr_batt_icon, b.state_of_charge * 100))
  end

  
  local TITLEBAR_COLOR = '#333333'
  -- Color palette for each cell
  local text_fg = '#c0c0c0'
  local colors = {
    TITLEBAR_COLOR,
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  local elements = {}
  while #cells > 0 and #colors > 1 do
    local text = table.remove(cells, 1)
    local prev_color = table.remove(colors, 1)
    local curr_color = colors[1]

    table.insert(elements, { Background = { Color = prev_color } })
    table.insert(elements, { Foreground = { Color = curr_color } })
    table.insert(elements, { Text = '' })
    table.insert(elements, { Background = { Color = curr_color } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
  end
  window:set_right_status(wezterm.format(elements))
end)

config.leader = { key=";", mods="CTRL", timeout_milliseconds=1000 }

local act = wezterm.action
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)
config.keys = {
  {
    key = '|',
    mods = 'SHIFT|LEADER',
    action = act.SplitHorizontal{domain="CurrentPaneDomain"},
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical{domain="CurrentPaneDomain"},
  },
  {
    key = 'h',
    mods = 'SHIFT|CTRL',
    action = act.ActivateCopyMode,
  },
  {
    key = 'Enter',
    mods = 'ALT',
    action = act.DisableDefaultAssignment,
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  {
    key = 'b',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}
      overrides.enable_tab_bar = not overrides.enable_tab_bar
      window:set_config_overrides(overrides)
    end),
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivateLastTab,
  },
  -- Switch to the default workspace
  {
    key = 'y',
    mods = 'CTRL|SHIFT',
    action = act.SwitchToWorkspace {
      name = 'default',
    },
  },
  -- Switch to a second-brain workspace, which will have `nvim` launched into it
  {
    key = 's',
    mods = 'CTRL|SHIFT',
    action = act.SwitchToWorkspace {
      name = 'second-brain',
      spawn = {
        args = { 'nvim', '.' },
        cwd = os.getenv("HOME") .. '/Projects/second-brain',
      },
    },
  },
  -- Create a new workspace with a random name and switch to it
  { key = 'i', mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace },
  -- Show the launcher in fuzzy selection mode and have it list all workspaces
  -- and allow activating one.
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
    -- Prompt for a name to use for a new workspace and switch to it.
  {
    key = 'W',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {key = "S", mods = "LEADER", action = act{EmitEvent = "save_session"}},
  {key = "L", mods = "LEADER", action = act{EmitEvent = "load_session"}},
  {key = "R", mods = "LEADER", action = act{EmitEvent = "restore_session"}},
  {key = "x", mods = "LEADER", action = act.CloseCurrentTab { confirm = true }},
}

-- default is true, has more "native" look
config.use_fancy_tab_bar = false

config.enable_scroll_bar = false
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"

config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'Ilum',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'Ilum',
    -- The username to use on the remote host
    username = 'przemek',
  },
  {
    name = 'dooku',
    remote_address = 'dooku',
    username = 'porebski',
  },
}

local function getHostname()
  local f = io.popen ("/bin/hostnamectl hostname")
  if not f then return 'not found' end
  local hostname = f:read("*a")
  hostname = hostname:gsub("\n", "")
  f:close()
  return hostname
end

local function work()
  local hostname = getHostname()
  return hostname == 'dooku'
end

local function work_setup(args)
  local project_path = wezterm.home_dir .. '/Projects/sentinel'
  local tab, pane, window = mux.spawn_window {
    cwd = project_path,
    args = args,
  }

  tab:set_title 'sentinel'
  pane:send_text 'tsh_login\n'
  pane:send_text 'vi .\n'
  local tab, pane, window = window:spawn_tab {
    cwd = wezterm.home_dir,
    args = args,
  }
  tab:set_title 'windows'
  pane:send_text 'if test "$(virsh domstate win10)" = "shut off";virsh start win10;sleep 10;end;\n'
  pane:send_text 'ssh windows\n'
  pane:send_text 'setup.bat\r\n'
end

local function home_setup(args)
  local tab, pane, window = mux.spawn_window {
    cwd = wezterm.home_dir,
    args = args,
  }
  tab:set_title 'home'
end

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then
    args = cmd.args
  end

  if work() then
    -- work_setup(args)
  else
    home_setup(args)
  end
end)


config.unix_domains = {
  {
    name = 'localhost',
  },
}

local session_manager = require("wezterm-session-manager/session-manager")
wezterm.on("save_session", function(window) session_manager.save_state(window) end)
wezterm.on("load_session", function(window) session_manager.load_state(window) end)
wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

-- and finally, return the configuration to wezterm
return config
