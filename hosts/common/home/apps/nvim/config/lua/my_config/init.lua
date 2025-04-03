require "my_config.set"
require "my_config.lsp"
require "my_config.project_nvim"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

if vim.g.neovide then
  vim.g.neovide_cursor_trail_legnth = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.o.guifont = "Jetbrains Mono"
end

require("notify").setup({
  background_colour = "#000000",
})

-- Enable Comment.nvim
require('Comment').setup()

-- Enable gitsigns.nvim
require('gitsigns').setup()

-- Turn on lsp status information
require('fidget').setup()

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

require("wf").setup({
  theme = "chad",
})

require("lspsaga").setup({})

require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
require("CopilotChat").setup {
  -- See Configuration section for options
}

local daily_notes_path = require("my_config.date_formatter_for_obsidian").get_formatted_path()
local daily_notes_day = require("my_config.date_formatter_for_obsidian").get_filename()

require("obsidian").setup({
  workspaces = {
    {
      name = "second-brain",
      path = "~/Projects/second-brain",
    },
  },
  follow_url_func = function(url)
    -- vim.fn.jobstart({"xdg-open", url})  -- linux
    vim.ui.open(url) -- need Neovim 0.10.0+
  end,
  templates = {
      folder = "~/Projects/second-brain/extras/templates/daily_note_template",
  },
  daily_notes = {
      folder = string.format("Timestamps/%s", daily_notes_path),
      date_format = string.format("%s", daily_notes_day),
      template = nil,
  },
})

require("pomo").setup({
    -- How often the notifiers are updated.
  update_interval = 1000,

  -- Configure the default notifiers to use for each timer.
  -- You can also configure different notifiers for timers given specific names, see
  -- the 'timers' field below.
  notifiers = {
    -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
    {
      name = "Default",
      opts = {
        -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
        -- continuously displayed. If you only want a pop-up notification when the timer starts
        -- and finishes, set this to false.
        sticky = true,

        -- Configure the display icons:
        title_icon = "󱎫",
        text_icon = "󰄉",
        -- Replace the above with these if you don't have a patched font:
        -- title_icon = "⏳",
        -- text_icon = "⏱️",
      },
    },

    -- The "System" notifier sends a system notification when the timer is finished.
    -- Available on MacOS and Windows natively and on Linux via the `libnotify-bin` package.
    { name = "System" },

    -- You can also define custom notifiers by providing an "init" function instead of a name.
    -- See "Defining custom notifiers" below for an example 👇
    -- { init = function(timer) ... end }
  },

  -- Override the notifiers for specific timer names.
  timers = {
    -- For example, use only the "System" notifier when you create a timer called "Break",
    -- e.g. ':TimerStart 2m Break'.
    Break = {
      { name = "System" },
    },
  },
})

require("my_config.avante")

require('my_config.blink_cmp').setup()
