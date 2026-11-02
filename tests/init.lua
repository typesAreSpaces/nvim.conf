-- Integration-test entry point: use installed plugins without fetching/building.
local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
vim.opt.rtp:prepend(root)
vim.opt.rtp:append(root .. '/after')
local plugin_root = vim.fn.stdpath('data') .. '/lazy/'
assert(vim.uv.fs_stat(plugin_root .. 'lazy.nvim'), 'Install plugins before running integration checks')
assert(vim.uv.fs_stat(plugin_root .. 'nvim-treesitter'), 'Install Treesitter before running integration checks')
vim.opt.rtp:prepend(plugin_root .. 'lazy.nvim')
vim.opt.rtp:prepend(plugin_root .. 'nvim-treesitter')
local install = require('nvim-treesitter.install')
install.ensure_installed = function() end
install.ensure_installed_sync = function() end

-- Lazy language plugins can enable servers after startup, too. Exercise their
-- configuration without launching external processes during tests/benchmarks.
local enable = vim.lsp.enable
vim.lsp.enable = function(configs) return enable(configs, false) end

local lazy = require('lazy')
local setup = lazy.setup
lazy.setup = function(spec, opts)
  opts = vim.tbl_deep_extend('force', opts or {}, {
    install = { missing = false },
    checker = { enabled = false },
    change_detection = { enabled = false },
  })
  setup(spec, opts)
end
dofile(root .. '/init.lua')
lazy.setup = setup
for name, plugin in pairs(require('lazy.core.config').plugins) do
  assert(vim.uv.fs_stat(plugin.dir), 'Missing plugin: ' .. name)
end
