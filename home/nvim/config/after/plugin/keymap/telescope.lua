local nnoremap = require "my_config.keymap".nnoremap

require('telescope').setup {
    defaults = {
        layout_config = {
            vertical = { width = 0.5 },
        },
        -- other layout configuration here
        file_ignore_patterns = {
            ".git/",
            "target/",
            "docs/",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "cscope*",
            "vcpkg/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            ".dart_tool/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "env/",
            "gradle/",
            "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
        },
        -- other defaults configuration here
        },
        pickers = {
            -- Your special builtin config goes in here
            buffers = {
                theme = "dropdown",
                mappings = {
                    i = {
                        ["<C-w>"] = require("telescope.actions").delete_buffer,
                        -- Right hand side can also be the name of the action as a string
                        ["<C-w>"] = "delete_buffer",
                    },
                    n = {
                        ["<C-w>"] = require("telescope.actions").delete_buffer,
                    }
                }
            }
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = false, -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    }

nnoremap("<C-p>", ":Telescope<cr>",
    { noremap = true, silent = true, desc = "[telescope] Telescope"})
nnoremap("<C-_>", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
    { noremap = true, silent = true, desc = "[telescope] current buffer fuzzy find"})
-- Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍
nnoremap("<leader>ff", ":lua require('telescope.builtin').find_files({ hidden=true })<cr>",
    { noremap = true, silent = true, desc = "[telescope] find files"})
nnoremap("<leader>gs", ":lua require('telescope.builtin').grep_string({ hidden=true })<cr>",
    { noremap = true, silent = true, desc = "[telescope] grep given string"})
nnoremap("<leader>gr", ":lua require('telescope.builtin').lsp_references()<cr>",
    { noremap = true, silent = true, desc = "[telescope] grep lsp references"})

nnoremap("<leader>fg", ":lua require('telescope.builtin').live_grep({ hidden=true })<cr>",
    { noremap = true, silent = true, desc = "[telescope] grep string"})
nnoremap("<leader>gf", ":lua require('telescope.builtin').git_files({ hidden=true })<cr>",
    { noremap = true, silent = true, desc = "[telescope] git files"})
-- nnoremap("<leader>gb", ":lua require('telescope.builtin').git_branches()<cr>")
-- https://stackoverflow.com/a/25941875
-- git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
nnoremap("<leader>gwt", ":Telescope git_worktree git_worktrees<cr>",
    { noremap = true, silent = true, desc = "[telescope] git worktrees"})
nnoremap("<leader>gwc", ":Telescope git_worktree create_git_worktree<cr>",
    { noremap = true, silent = true, desc = "[telescope] create git worktree"})
-- nnoremap("<leader>fs ,":lua require('telescope.builtin') grep_string<cr>
nnoremap("<leader>fb", ":lua require('telescope.builtin').buffers()<cr>",
    { noremap = true, silent = true, desc = "[telescope] buffers"})
nnoremap("<leader>fh", ":lua require('telescope.builtin').help_tags()<cr>",
    { noremap = true, silent = true, desc = "[telescope] help tags"})
nnoremap("<leader>fm", ":lua require('telescope.builtin').marks()<cr>",
    { noremap = true, silent = true, desc = "[telescope] marks"})
nnoremap("<leader>ws", ":lua require('telescope.builtin').lsp_document_symbols()<cr>",
    { noremap = true, silent = true, desc = "[telescope] lsp document symbols"})
