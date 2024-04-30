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

config.font_size = 10.0
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

config.leader = { key=";", mods="CTRL", timeout_milliseconds=1000 }
config.keys = {
  {
    key = '|',
    mods = 'SHIFT|LEADER',
    action = wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"},
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical{domain="CurrentPaneDomain"},
  },
  {
    key = 'h',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ActivateCopyMode,
  },
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = wezterm.action.ShowTabNavigator,
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
    action = wezterm.action.ActivateLastTab,
  },
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

local system_username = os.getenv('USERNAME');
print(system_username);
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

-- and finally, return the configuration to wezterm
return config
