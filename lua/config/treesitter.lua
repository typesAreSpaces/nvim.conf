-- Neovim 0.12 removed the all=false compatibility option used by the
-- legacy nvim-treesitter branch. Adapt its custom query handlers to node lists.
if vim.fn.has('nvim-0.12') == 1 then
  local query = vim.treesitter.query
  local add_predicate, add_directive = query.add_predicate, query.add_directive
  local function adapt(register)
    return function(name, handler, opts)
      if type(opts) == 'table' and opts.all == false then
        local legacy_handler = handler
        handler = function(match, ...)
          local nodes = {}
          for id, captures in pairs(match) do
            nodes[id] = captures[1]
          end
          return legacy_handler(nodes, ...)
        end
      end
      return register(name, handler, opts)
    end
  end
  query.add_predicate = adapt(add_predicate)
  query.add_directive = adapt(add_directive)
  -- The plugin can load these handlers before its configuration runs.
  package.loaded['nvim-treesitter.query_predicates'] = nil
  local ok, err = pcall(require, 'nvim-treesitter.query_predicates')
  query.add_predicate, query.add_directive = add_predicate, add_directive
  if not ok then error(err) end
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "bibtex", "c", "cmake", "cpp", "javascript", "json", "julia", "latex", "lua", "make", "markdown", "python", "rust", "toml", "typescript", "vim", "vimdoc", "yaml" },
  ignore_install = {},
  incremental_selection = { enable = true,
    keymaps = {
      init_selection = "ti",
      node_incremental = "tn",
      scope_incremental = "tt",
      node_decremental = "tp",
    },
  },
  highlight = {
    enable = true, 
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
