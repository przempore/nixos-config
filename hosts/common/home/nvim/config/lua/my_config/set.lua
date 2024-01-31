vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4 
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.nu = true
-- vim.inspect(vim.opt.wrap:get())
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false

if vim.loop.os_uname().sysname == "Linux" then
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

vim.o.completeopt = 'menuone,noselect'
vim.opt.equalalways = false

vim.opt.colorcolumn = "100"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.notify = require("notify")

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

vim.g.go_def_mode='gopls'
vim.g.go_info_mode='gopls'

-- netrw stuff {{{
-- vim.cmd([[
-- autocmd FileType netrw setl bufhidden=delete
-- ]])
-- }}}
