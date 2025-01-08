local Remap = require("my_config.keymap")

require("lspconfig").lua_ls.setup{}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}

local function on_attach()

end

local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
    }, _config or {})
end

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local clangd_capabilities = cmp_capabilities
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding ="utf-8"

require('lspconfig').clangd.setup {
    capabilities = clangd_capabilities,
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--background-index",
        "-j=14",
        "--pch-storage=memory",
        -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
        -- to add more checks, create .clang-tidy file in the root directory
        -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
        "--clang-tidy",
    },
    init_options = {
        clangdFileStatus = true, -- Provides information about activity on clangd’s per-file worker thread
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    -- root_dir = util.root_pattern("compile_flags.txt") or util.root_pattern(".git"),
    single_file_support = true,
    root_dir = function() return vim.loop.cwd() end
}

require('lspconfig').pyright.setup{}
require('lspconfig').neocmake.setup{}
require('lspconfig').jsonls.setup{}
require('lspconfig').marksman.setup{}
require('lspconfig').ruby_lsp.setup{}
require('lspconfig').qmlls.setup{} -- qml language server provided by e.g. pkgs.qt6.qtdeclarative in nixpkgs

require('lspconfig').rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                enabled = true,
                disabled = {"unresolved-proc-macro"},
                enableExperimental = true,
            },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
                ignored = {
                    leptos_macro = {
                        -- optional: --
                        -- "component",
                        "server",
                    },
                },
            },
        }
    }
})

local util = require('lspconfig/util')
require('lspconfig').gopls.setup {
    on_attach = on_attach,
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },
}
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
    end
})

require('lspconfig').nixd.setup{}
