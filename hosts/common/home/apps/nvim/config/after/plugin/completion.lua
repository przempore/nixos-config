local is_wsl = vim.env.USER == "tj-wsl"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append "c"

local ok, lspkind = pcall(require, "lspkind")
if not ok then
  return
end

lspkind.init()

local cmp = require "cmp"

cmp.setup {
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<c-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),

    -- ["<C-j>"] = cmp.mapping(function(fallback)
    --   cmp.mapping.abort()
    --   local copilot_keys = vim.fn["copilot#Accept"]()
    --   if copilot_keys ~= "" then
    --     vim.api.nvim_feedkeys(copilot_keys, "i", true)
    --   else
    --     fallback()
    --   end
    -- end
    -- ),

    ["<c-space>"] = cmp.mapping {
      i = cmp.mapping.complete(),
      c = function(
        _ --[[fallback]]
      )
        if cmp.visible() then
          if not cmp.confirm { select = true } then
            return
          end
        else
          cmp.complete()
        end
      end,
    },

    -- ["<tab>"] = false,
    ["<tab>"] = cmp.config.disable,

    -- Testing
    ["<c-q>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },

  -- Youtube:
  --    the order of your sources matter (by default). That gives them priority
  --    you can configure:
  --        keyword_length
  --        priority
  --        max_item_count
  --        (more?)
  sources = {
    -- Copilot Source
    { name = "copilot", group_index = 2 },
    -- Youtube: Could enable this only for lua, but nvim_lua handles that already.
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "gh_issues" },

    { name = "path" },
    -- { name = "cmp_tabnine" },
    { name = "luasnip" },
    -- { name = "buffer", keyword_length = 5 },
  },

  sorting = {
    -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own.
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  -- Youtube: mention that you need a separate snippets plugin
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      symbol_map = { Copilot = "" },
                     -- can also be a function to dynamically calculate max width such as 
                     -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      -- before = function (entry, vim_item)
      --   ...
      --   return vim_item
      -- end
    })
  },


  -- formatting = {
  --   -- Youtube: How to set up nice formatting for your sources.
  --   format = lspkind.cmp_format {
  --     
  --     with_text = true,
  --     mode = "symbol_text",
  --     max_width = 50,
  --     -- menu = {
  --     --   buffer = "[buf]",
  --     --   nvim_lsp = "[LSP]",
  --     --   nvim_lua = "[api]",
  --     --   path = "[path]",
  --     --   luasnip = "[snip]",
  --     --   gh_issues = "[issues]",
  --     -- },
  --     preset = 'codicons',
  --     symbol_map = {
  --       Copilot = "",
  --       Text = "󰉿",
  --       Method = "󰆧",
  --       Function = "󰊕",
  --       Constructor = "",
  --       Field = "󰜢",
  --       Variable = "󰀫",
  --       Class = "󰠱",
  --       Interface = "",
  --       Module = "",
  --       Property = "󰜢",
  --       Unit = "󰑭",
  --       Value = "󰎠",
  --       Enum = "",
  --       Keyword = "󰌋",
  --       Snippet = "",
  --       Color = "󰏘",
  --       File = "󰈙",
  --       Reference = "󰈇",
  --       Folder = "󰉋",
  --       EnumMember = "",
  --       Constant = "󰏿",
  --       Struct = "󰙅",
  --       Event = "",
  --       Operator = "󰆕",
  --       TypeParameter = "",
  --     },
  --   },
  -- },

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = true,
  },
}

-- Add vim-dadbod-completion in sql files
_ = vim.cmd [[
  augroup DadbodSql
    au!
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
  augroup END
]]

_ = vim.cmd [[
  augroup CmpZsh
    au!
    autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
  augroup END
]]
