require('avante_lib').load()
-- Store the configuration in a variable
local avante_config = {
  auto_suggestions_provider = "claude",
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-5-sonnet-20241022",
    temperature = 0,
    max_tokens = 4096,
  },
  openai = {  -- Added openai configuration
    endpoint = "https://api.openai.com/v1",
    model = "o3-mini",
    temperature = 0,
    max_tokens = 4096,
  },
  provider = "claude",
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000,
  },
  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true,
  },
  mappings = {
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    position = "right",
    wrap = true,
    width = 30,
    sidebar_header = {
      enabled = true,
      align = "center",
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8,
    },
    edit = {
      border = "rounded",
      start_insert = true,
    },
    ask = {
      floating = false,
      start_insert = true,
      border = "rounded",
      focus_on_apply = "ours",
    },
  },
  highlights = {
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  diff = {
    autojump = true,
    list_opener = "copen",
    override_timeoutlen = 500,
  },
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
}


-- Setup avante with the configuration
require("avante").setup(avante_config)

local models = {
  ["Claude 3.5 Sonnet"] = {
    provider = "claude",
    model = "claude-3-5-sonnet-20241022",
  },
  ["Claude 3.7 Opus"] = {
    provider = "claude",
    model = "claude-3-7-sonnet-20250219",
  },
  ["GPT-o3-mini"] = {
    provider = "openai",
    model = "o3-mini",
  },
  ["GPT-4o-mini"] = {
    provider = "openai",
    model = "gpt-4o-mini",
  },
  ["gpt-4o-mini-search-preview"] = {
    provider = "openai",
    model = "gpt-4o-mini-search-preview",
  },
  ["gpt-4.1-mini"] = {
    provider = "openai",
    model = "gpt-4.1-mini",
  }
}

-- Function to switch models
local function switch_model(selected_config)
  local avante = require("avante")
  -- Use a deepcopy of the stored configuration instead of require("avante").config
  local config = vim.deepcopy(avante_config)

  config.provider = selected_config.provider
  if selected_config.provider == "claude" then
    config.claude.model = selected_config.model
  elseif selected_config.provider == "openai" then
    config.openai.model = selected_config.model
  end

  avante.setup(config)
  vim.notify("Switched to " .. selected_config.model, vim.log.levels.INFO)
end

-- Function to show model selector
local function select_model()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local model_names = {}
  for name, _ in pairs(models) do
    table.insert(model_names, name)
  end

  local telescope_theme = require("telescope.themes").get_dropdown({
    prompt_title = "Select AI Model",
    width = 0.5,
  })
  pickers.new(telescope_theme, {
    finder = finders.new_table({
      results = model_names
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local selected_config = models[selection[1]]
        switch_model(selected_config)
      end)
      return true
    end,
  }):find()
end

-- Add command to switch models
vim.api.nvim_create_user_command('AvanteSelectModel', select_model, {})

vim.keymap.set('n', '<leader>am', ':AvanteSelectModel<CR>', { noremap = true, silent = true, desc = "Switch AI Model" })

