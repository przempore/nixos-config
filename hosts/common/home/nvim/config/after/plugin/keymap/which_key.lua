local which_key = require("wf.builtin.which_key")
local register = require("wf.builtin.register")
local bookmark = require("wf.builtin.bookmark")
local buffer = require("wf.builtin.buffer")
local mark = require("wf.builtin.mark")

-- Register
vim.keymap.set( "n", "<leader>wr", register(),
  { noremap = true, silent = true, desc = "[which key] register" }
)

-- Buffer
vim.keymap.set( "n", "<leader>wbu", buffer({}),
  {noremap = true, silent = true, desc = "[which key] buffer"}
)

-- Mark
vim.keymap.set( "n", "'", mark(),
  {nowait = true, noremap = true, silent = true, desc = "[which key] mark"}
)

-- Which Key
vim.keymap.set( "n", "<leader>", which_key({ text_insert_in_advance = "<Space>" }),
  { noremap = true, silent = true, desc = "[which key] which-key /", }
)
