local nnoremap = require "my_config.keymap".nnoremap

nnoremap("<leader>gc", ":GBranches<cr>", { noremap = true, silent = true, desc = "[Git] Branches"});
nnoremap("<leader>gb", ":GBrowse<cr>", { noremap = true, silent = true, desc = "[Git] Browse"});
