local Remap = require("my_config.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local tnoremap = Remap.tnoremap
local nmap = Remap.nmap

nnoremap("<leader>pv", ":Ex<CR>",
    { noremap = true, silent = true, desc = "[misc] File explorer"})
nnoremap("<leader>u", ":UndotreeShow<CR>",
    { noremap = true, silent = true, desc = "[Undotree] Show"})

vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

nnoremap("Y", "yg$")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

nnoremap("<C-j>", "<cmd>cnext<CR>zz")
nnoremap("<C-k>", "<cmd>cprev<CR>zz")

nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", 
    { noremap = true, silent = true, desc = "[misc] Rename in file"})
nnoremap("<leader>fr", Remap.format(), { noremap = true, silent = true, desc = "[code] format", })

-- greatest remap ever
xnoremap("<leader>p", "\"_dP",
    { noremap = true, silent = true, desc = "[misc] Paste"})

-- next greatest remap ever : asbjornHaland
nnoremap(",y", "\"+y",
    { noremap = true, silent = true, desc = "[misc] Copy"})
vnoremap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")

nnoremap("<leader>d", "\"_d")
vnoremap("<leader>d", "\"_d")

vnoremap("<leader>d", "\"_d")

inoremap("<C-c>", "<Esc>")

tnoremap("<Esc>", "<C-\\><C-n>")

nnoremap("<F1>", ":tabp<cr>")
nnoremap("<F2>", ":tabn<cr>")
nnoremap("<F8>", function() vim.opt.wrap = not vim.wo.wrap; print("line wrap:", vim.wo.wrap) end)
nnoremap("<F10>", ":ClangdSwitchSourceHeader<CR>")

-- resizing
nnoremap("<A-k>", ":resize +5 <cr>")
nnoremap("<A-j>", ":resize -5 <cr>")
nnoremap("<A-l>", ":vertical:resize -5 <cr>")
nnoremap("<A-h>", ":vertical:resize +5 <cr>")

nnoremap("<leader>nt", ":NERDTreeToggle<CR>")
nnoremap("<leader>0", ":NERDTreeFind<CR>")

nnoremap("<leader>z", "<cmd>:lua require(\"zen-mode\").toggle({ window = { width = .85 } })<cr>",
    { noremap = true, silent = true, desc = "[Zen mode] Togle"})

nnoremap("<leader>gu", "<cmd>diffget //2<CR>",
    { noremap = true, silent = true, desc = "[Git] Accept <<< changes"})
nnoremap("<leader>gh", "<cmd>diffget //3<CR>",
    { noremap = true, silent = true, desc = "[Git] Accept >>> changes"})

nnoremap("<leader>cr", "<cmd>!find . -name \"*.c\" -o -name \"*.cpp\" -o -name \"*.h\" -o -name \"*.hpp\" > cscope.files; cscope -q -R -b -i cscope.files<CR>",
    { noremap = true, silent = true, desc = "[cscope] Create database"})
