local nnoremap = require "my_config.keymap".nnoremap

require("project_nvim").setup {
  show_hidden = false,
}

local telescope = require('telescope')
telescope.load_extension('projects')

nnoremap("<leader>fp", function() telescope.extensions.projects.projects{} end,
    { noremap = true, silent = true, desc = "[telescope] Telescope projects"})
