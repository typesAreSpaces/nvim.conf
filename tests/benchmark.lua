-- Invoked by benchmark.py after startup; timed work uses installed plugins only.
local function run()
  local plugins = require('lazy.core.config').plugins
  local loaded, costs = {}, {}
  for name, plugin in pairs(plugins) do
    if plugin._.loaded then
      loaded[#loaded + 1] = name
      costs[#costs + 1] = { name = name, ms = (plugin._.loaded.time or 0) / 1e6 }
    end
  end
  table.sort(costs, function(a, b) return a.ms > b.ms end)
  local action = vim.env.NVIM_BENCH_ACTION
  local started = vim.uv.hrtime()
  if action == 'insert' then
    vim.api.nvim_exec_autocmds('InsertEnter', { modeline = false })
  elseif action == 'command' then
    vim.api.nvim_exec_autocmds('CmdlineEnter', { pattern = ':', modeline = false })
  end
  local action_ms = (vim.uv.hrtime() - started) / 1e6
  vim.fn.writefile({ vim.json.encode({ loaded = #loaded, plugin_costs = costs, first_action_ms = action_ms }) },
    vim.env.NVIM_BENCH_RESULT)
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd('cquit 1')
end
vim.cmd('qa!')
