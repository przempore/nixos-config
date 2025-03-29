local status_ok, blink_cmp = pcall(require, "blink-cmp")
if not status_ok then
  print("ERROR: blink.cmp plugin not found")
  return
end

-- Autocommands for Copilot integration (run these when setting up)
vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuOpen",
    desc = "Hide Copilot suggestions when blink.cmp menu opens",
    callback = function()
        -- Check if the copilot function exists before calling
        local copilot_suggestion = package.loaded["copilot.suggestion"]
        if copilot_suggestion and copilot_suggestion.dismiss then
             copilot_suggestion.dismiss()
        end
        vim.b.copilot_suggestion_hidden = true
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "BlinkCmpMenuClose",
    desc = "Show Copilot suggestions when blink.cmp menu closes",
    callback = function()
        vim.b.copilot_suggestion_hidden = false
    end,
})


local function setup_tab_keymaps()
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if not luasnip_ok then
    print("WARNING: luasnip not found, <Tab> bindings for snippets might not work.")
  end

  -- Custom Tab mapping using vim.keymap.set
  vim.keymap.set("i", "<Tab>", function()
    -- Check if completion menu is visible (pumvisible is a good guess)
    if vim.fn.pumvisible() == 1 then
      -- If PUM is visible, let <C-n>/<C-p> handle selection.
      -- We return an empty string for expr mapping to signify "do nothing".
      return ""
    -- Check if luasnip is available and we can expand or jump
    elseif luasnip_ok and luasnip.expand_or_jumpable() then
      -- If snippet is active, expand/jump
      return vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true)
    else
      -- Otherwise, insert a literal tab
      return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    end
  end, { expr = true, noremap = true, silent = true, desc = "Completion/Snippet Tab" })

  -- Custom Shift-Tab mapping using vim.keymap.set
  vim.keymap.set("i", "<S-Tab>", function()
    -- Check if completion menu is visible
    if vim.fn.pumvisible() == 1 then
      -- If PUM is visible, let <C-n>/<C-p> handle selection. Do nothing.
      return ""
    -- Check if luasnip is available and we can jump backwards
    elseif luasnip_ok and luasnip.jumpable(-1) then
      -- If snippet is active, jump back
      return vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true)
    else
      -- Otherwise, do nothing
      return ""
    end
  end, { expr = true, noremap = true, silent = true, desc = "Completion/Snippet S-Tab" })

  -- print("Custom Tab/S-Tab keymaps set.")
end

-- Call the function to set the keymaps
-- Make sure this is called AFTER plugins are loaded
setup_tab_keymaps()


local M = {}

function M.setup()
  -- Load dependency modules safely
  local icons_ok, devicons = pcall(require, "nvim-web-devicons")
  local lspkind_ok, lspkind = pcall(require, "lspkind")

  if not lspkind_ok then
    print("WARNING: lspkind.nvim not found, icons might be missing.")
  end

  blink_cmp.setup({
    appearance = {
      -- use_nvim_cmp_as_default = true, -- Keep if you like the style
      nerd_font_variant = "mono", -- Or your preferred variant
    },
    completion = {
      documentation = {
        auto_show = true,
        window = {
          border = "rounded", -- Use your preferred border
        },
      },
      ghost_text = { enabled = true }, -- Enable/disable ghost text (like Copilot)
      menu = {
        border = "rounded", -- Use your preferred border
        draw = {
          -- Define how completion items are laid out
          columns = {
            { "kind_icon", "kind", gap = 1 }, -- Kind icon and text
            { "label", "label_description", gap = 1 }, -- Main label
            { "source_name" }, -- Source indicator
          },
          -- Customize components (icons, text formatting)
          components = {
            source_name = {
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
              -- highlight = "Comment", -- Optional highlight
            },
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local icon = ctx.kind_icon -- Default icon from blink.cmp

                if vim.tbl_contains({ "Path" }, ctx.source_name) and icons_ok then
                  local dev_icon, _ = devicons.get_icon(ctx.label)
                  if dev_icon then icon = dev_icon end
                elseif ctx.source_name == "Copilot" then
                   icon = "" -- Copilot icon (ensure Nerd Font)
                elseif lspkind_ok then
                   -- Use lspkind for LSP and other sources if available
                   icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
                end
                -- Ensure there's always a fallback icon string if others fail
                icon = (type(icon) == 'string' and #icon > 0) and icon or '?'

                return icon .. ctx.icon_gap
              end,
              highlight = function(ctx)
                 local hl = ctx.kind_hl -- Default highlight
                 if vim.tbl_contains({ "Path" }, ctx.source_name) and icons_ok then
                    local dev_icon, dev_hl = devicons.get_icon(ctx.label)
                    if dev_icon and dev_hl then hl = dev_hl end
                 end
                 -- Ensure hl is a valid string or nil
                 return (type(hl) == 'string' and #hl > 0) and hl or nil
              end,
            },
          },
        },
      },
    },
    keymap = {
      -- preset = "default", -- You might remove preset if fully customizing below
      -- Navigation: Use C-p/C-n
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      -- Scrolling documentation
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },

      -- Acceptance: Use C-y
      ["<C-y>"] = { "accept", "fallback" },

      -- Cancellation
      ["<C-c>"] = { "cancel" },
      ["<Esc>"] = { "cancel", "fallback" }, -- Good practice to allow Esc

      -- Decide what Enter should do now (e.g., just insert newline)
      ["<CR>"] = { "fallback" }, -- Let CR just insert a newline if menu is visible
    }, -- End of keymap table
    -- signature = { enabled = true }, -- Enable signature help if desired
    sources = {
      -- Define the order and enabled sources
      default = { "lsp", "snippets", "buffer", "path" }, -- Removed copilot for now unless specifically configured
      providers = {
        buffer = { max_items = 5 },
        lsp = { score_offset = 5 }, -- Prioritize LSP slightly
        path = { max_items = 3 },
        snippets = { score_offset = 2 }, -- Ensure snippets source name matches (often 'luasnip')
        -- Example for luasnip if source name is different
        -- luasnip = { score_offset = 2 },
      },
    },
  })

  print("blink.cmp configured")
end

return M
