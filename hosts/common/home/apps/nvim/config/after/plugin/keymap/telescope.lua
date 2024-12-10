local nnoremap = require "my_config.keymap".nnoremap

require('telescope').setup {
    defaults = {
        layout_config = {
            vertical = { width = 0.8 },
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
                -- theme = "dropdown",
                theme = "ivy",
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
            },
            find_files = {
                theme = "ivy",
            },
            current_buffer_fuzzy_find = {
                theme = "ivy",
            },
            grep_string = {
                theme = "ivy",
            },
            live_grep = {
                theme = "ivy",
            },
            lsp_references = {
                theme = "ivy",
            },
            git_files = {
                theme = "ivy",
            },
            lsp_document_symbols = {
                theme = "ivy",
            },
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

local telescope = require "telescope.builtin";


nnoremap("<C-p>", ":Telescope<cr>",
    { noremap = true, silent = true, desc = "[telescope] Telescope"})
nnoremap("<C-_>", function() telescope.current_buffer_fuzzy_find(); end,
    { noremap = true, silent = true, desc = "[telescope] current buffer fuzzy find"})
nnoremap("<C-/>", function() telescope.current_buffer_fuzzy_find(); end,
    { noremap = true, silent = true, desc = "[telescope] current buffer fuzzy find"})
nnoremap("<leader>ff", function() telescope.find_files({ hidden=true }); end,
    { noremap = true, silent = true, desc = "[telescope] find files"})
nnoremap("<leader>gs", function() telescope.grep_string({ hidden=true }); end,
    { noremap = true, silent = true, desc = "[telescope] grep given string"})
nnoremap("<leader>gr", function() telescope.lsp_references(); end,
    { noremap = true, silent = true, desc = "[telescope] grep lsp references"})

nnoremap("<leader>fs", function() telescope.live_grep({ hidden=true }); end,
    { noremap = true, silent = true, desc = "[telescope] grep string"})
nnoremap("<leader>gf", function() telescope.git_files({ hidden=true }); end,
    { noremap = true, silent = true, desc = "[telescope] git files"})
nnoremap("<leader>fb", function() telescope.buffers(); end,
    { noremap = true, silent = true, desc = "[telescope] buffers"})
nnoremap("<leader>fh", function() telescope.help_tags(); end,
    { noremap = true, silent = true, desc = "[telescope] help tags"})
nnoremap("<leader>fm", function() telescope.marks(); end,
    { noremap = true, silent = true, desc = "[telescope] marks"})
nnoremap("<leader>ws", function() telescope.lsp_document_symbols(); end,
    { noremap = true, silent = true, desc = "[telescope] lsp document symbols"})
-- https://stackoverflow.com/a/25941875
-- git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
nnoremap("<leader>gwt", ":Telescope git_worktree git_worktrees<cr>",
    { noremap = true, silent = true, desc = "[telescope] git worktrees"})
nnoremap("<leader>gwc", ":Telescope git_worktree create_git_worktree<cr>",
    { noremap = true, silent = true, desc = "[telescope] create git worktree"})
