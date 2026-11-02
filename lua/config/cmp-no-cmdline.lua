vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
local cmp = require'cmp'
local performance = require('config.performance')
local default_enabled = cmp.get_config().enabled

local press = function(key)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
end

cmp.setup({
  enabled = function()
    if performance.is_large(0) then return false end
    if type(default_enabled) == 'function' then return default_enabled() end
    return default_enabled
  end,
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  }, 
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping(function()
      if cmp.visible() then
        if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
          return press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
        end
        cmp.select_next_item()
      else
        cmp.complete()
      end
    end, {"i","s"}), 
    ["<C-g>"] = cmp.mapping.abort(),
    ["<C-j>"] = cmp.mapping({
      i = function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          vim.fn["UltiSnips#JumpForwards"]()
        else
          fallback()
        end
      end,
      s = function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          vim.fn["UltiSnips#JumpForwards"]()
        else
          fallback()
        end
      end,
      c = cmp.config.disable,
    }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
        vim.fn["UltiSnips#JumpBackwards"]()
      else
        fallback()
      end
    end, {"i","s",}),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, {"i","s",}),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {"i","s",})
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { 
      name = 'ultisnips',
      keyword_length = 3,
    },
    { 
      name = 'buffer',
      keyword_length = 3,
      option = {
        get_bufnrs = function()
          return performance.is_large(0) and {} or { vim.api.nvim_get_current_buf() }
        end,
      }
    },
    { name = 'path' }
  }) 
}) 
