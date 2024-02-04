local nnoremap = require "my_config.keymap".nnoremap

nnoremap("<leader>la","<cmd>Lspsaga code_action<CR>",
      { noremap = true, silent = true, desc = "[LspSaga] Code Action" })
-- Rename all occurrences of the hovered word for the selected files
nnoremap("<leader>lrn", "<cmd>Lspsaga rename ++project<CR>",
      { noremap = true, silent = true, desc = "[LspSaga] Rename in Project" })

-- LSP finder - Find the symbol's definition
-- If there is no definition, it will instead be hidden
-- When you use an action in finder like "open vsplit",
-- you can use <C-t> to jump back
nnoremap("<leader>lh", "<cmd>Lspsaga lsp_finder<CR>",
      { noremap = true, silent = true, desc = "[LspSaga] Lsp Finder" })
-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
nnoremap("<leader>lp", "<cmd>Lspsaga peek_definition<CR>",
      { noremap = true, silent = true, desc = "[LspSaga] Peek Definition" })
-- Go to definition
nnoremap("<leader>ld", "<cmd>Lspsaga goto_definition<CR>",
      { noremap = true, silent = true, desc = "[LspSaga] Go to Definition" })
-- Peek type definition
-- You can edit the file containing the type definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
nnoremap("<leader>lt", "<cmd>Lspsaga peek_type_definition<CR>",
      { noremap = true, silent = true, desc = "[LspSaga] Peek Type Definition" })
