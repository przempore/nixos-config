local Remap = require("my_config.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<leader>gu", "<cmd>diffget //2<CR>",
    { noremap = true, silent = true, desc = "[Git] Accept <<< changes"})
nnoremap("<leader>gh", "<cmd>diffget //3<CR>",
    { noremap = true, silent = true, desc = "[Git] Accept >>> changes"})

nnoremap("<leader>gp", "V:diffput<CR>",
    { noremap = true, silent = true, desc = "[Git] Put changes into diff" })
nnoremap("<leader>gg", "V:diffget<CR>",
    { noremap = true, silent = true, desc = "[Git] Get changes from diff" })
