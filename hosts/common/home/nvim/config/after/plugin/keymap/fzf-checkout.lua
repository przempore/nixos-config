local nnoremap = require "my_config.keymap".nnoremap

nnoremap("<leader>gc", ":GBranches<cr>", { noremap = true, silent = true, desc = "[Git] Branches"});
nnoremap("<leader>gb", ":GBrowse<cr>", { noremap = true, silent = true, desc = "[Git] Browse"});

local telescope = require('telescope.builtin')
nnoremap("<leader>gl", function() telescope.git_commit() end,
    { noremap = true, silent = true, desc = "[Git] show commits"});
