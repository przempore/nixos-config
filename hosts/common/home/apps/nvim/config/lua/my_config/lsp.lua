local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

local clangd_capabilities = vim.deepcopy(capabilities)
clangd_capabilities.textDocument.semanticHighlighting = true
-- If using clangd >= 11, offsetEncoding defaults to utf-8, otherwise set explicitly
-- clangd_capabilities.offsetEncoding = "utf-8"

local function on_attach(client, bufnr)
  print("LSP client " .. client.name .. " attached via lspconfig to buffer " .. bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }

  -- Use lspsaga for hover if available, otherwise default LSP hover
  local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
  if lspsaga_ok then
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts)
    -- Optional: Use lspsaga for other actions too for consistent UI
    -- vim.keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<CR>', bufopts)
    -- vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', bufopts)
    -- vim.keymap.set('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', bufopts) -- Example for rename
    -- vim.keymap.set('n', '<leader>d', '<cmd>Lspsaga show_line_diagnostics<CR>', bufopts) -- Example for diagnostics
  else
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  end

  -- Standard LSP actions (use defaults if lspsaga wasn't used above)
  if not (lspsaga_ok and vim.fn.maparg('gd', 'n') ~= '') then -- Check if gd wasn't already mapped by lspsaga block
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  end
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, bufopts) -- Often 'gy' or 'gtd'

  -- Use Telescope for references (as previously configured in keymap/lsp.lua)
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then
    vim.keymap.set('n', 'grr', telescope.lsp_references, bufopts)
  else
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, bufopts) -- Fallback if telescope not found
  end

  -- Code Actions (use default if lspsaga wasn't used)
  -- if not (lspsaga_ok and vim.fn.maparg('<leader>ca', 'n') ~= '') then
  --     vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  --     -- Consider adding visual mode mapping too
  --     vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  -- end

  -- Rename (use default if lspsaga wasn't used)
  -- if not (lspsaga_ok and vim.fn.maparg('<leader>rn', 'n') ~= '') then
  --    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  -- end

  -- Workspace Symbols
  vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, { desc = "[LSP] Workspace Symbols"}) -- remove bufopts if telescope used below
  -- Or use Telescope for workspace symbols:
  if telescope_ok then
     vim.keymap.set('n', '<leader>ws', telescope.lsp_document_symbols, { desc = "[LSP] Workspace Symbols (Telescope)"})
  end


  -- Diagnostics (use defaults or lspsaga)
  if not (lspsaga_ok and vim.fn.maparg('<leader>d', 'n') ~= '') then
     vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = "[LSP] Show Line Diagnostics"})
  end
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
  -- Consider mapping <leader>qf to vim.diagnostic.setloclist()

  -- Signature Help (triggered in Insert mode)
  vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, bufopts)

end
-- ... (rest of your lsp.lua, including the lspconfig setup calls which should all have on_attach = on_attach) ...

-- Keep the handler/diagnostic configuration for borders, it's fine
local border_opts = { border = vim.o.winborder }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts) -- Harmless fallback
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)
vim.diagnostic.config({ float = { border = vim.o.winborder, source = "always" } })

-- local function on_attach(client, bufnr)
--   print("LSP client " .. client.name .. " attached via lspconfig to buffer " .. bufnr)
--   local bufopts = { noremap=true, silent=true, buffer=bufnr }
--
--     -- Check if lspsaga hover is available and map K to it
--   local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
--   local hover_ok = lspsaga_ok and pcall(function() return lspsaga.hover end) -- Check specifically for hover module/function
--
--   if hover_ok then
--     -- Use lspsaga hover
--     vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', bufopts) -- Use Lspsaga command for hover
--     -- print("Mapped K to lspsaga hover") -- Optional debug
--   else
--     -- Fallback to default LSP hover if lspsaga or its hover is not available
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--     -- print("Mapped K to default LSP hover (lspsaga hover not found)") -- Optional debug
--   end
--   -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
--   -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
--   -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
--   -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
--   -- Add other mappings
-- end

local lspconfig = require('lspconfig')

-- Configure servers using lspconfig
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { Lua = { runtime = { version = 'LuaJIT' }, diagnostics = { globals = {'vim'} } } } -- Example settings
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = clangd_capabilities, -- Pass specific capabilities
  cmd = { -- You can still override cmd if needed, but often not necessary if in PATH
    "clangd", "--background-index", "-j=14", "--pch-storage=memory", "--clang-tidy",
  },
  init_options = { clangdFileStatus = true, usePlaceholders = true, completeUnimported = true, semanticHighlighting = true },
  -- root_dir = ... -- Only override if default detection fails
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.neocmake.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.marksman.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.ruby_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.qmlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { -- Pass your specific rust-analyzer settings
    ['rust-analyzer'] = { diagnostics = { enabled = true, disabled = {"unresolved-proc-macro"}, enableExperimental = true }, imports = { granularity = { group = "module" }, prefix = "self" }, cargo = { buildScripts = { enable = true } }, procMacro = { enable = true, ignored = { leptos_macro = { "server" } } } }
  },
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true, usePlaceholders = true } }
}

lspconfig.nixd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Configure diagnostic floating windows too
vim.diagnostic.config({
  float = {
    border = vim.o.winborder,
    source = "always", -- Optional: show diagnostic source
  }
})

local function toggle_virtual_lines()
    local current_virtual_lines = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_lines = not current_virtual_lines
    })
    vim.notify("Virtual lines " .. (not current_virtual_lines and "enabled" or "disabled"))
end

-- Set initial virtual_lines state
vim.diagnostic.config({
    virtual_lines = false
})

-- Keybinding to toggle virtual_lines
vim.keymap.set('n', '<leader>vl', toggle_virtual_lines, { desc = "Toggle virtual diagnostic lines" })

-- print("LSP configured using nvim-lspconfig")
