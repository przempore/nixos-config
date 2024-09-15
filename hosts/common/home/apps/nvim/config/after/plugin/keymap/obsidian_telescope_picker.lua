local function get_obsidian_commands()
  local commands = {}
  for name, _ in pairs(vim.api.nvim_get_commands({})) do
    if name:match("^Obsidian") then
      table.insert(commands, name)
    end
  end
  return commands
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function obsidian_picker(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Obsidian Commands",
    finder = finders.new_table {
      results = get_obsidian_commands(),
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.api.nvim_command(selection[1])
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("ObsidianPicker", obsidian_picker, {})
vim.api.nvim_set_keymap('n', '<leader>ob', ':ObsidianPicker<CR>', { noremap = true, silent = true  })
